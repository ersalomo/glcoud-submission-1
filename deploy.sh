#!/bin/bash
# =====================================================================
# deploy.sh - Script deployment Profile App ke Google Cloud
# =====================================================================
# Cara pakai:
#   chmod +x deploy.sh
#   ./deploy.sh YOUR_PROJECT_ID YOUR_BUCKET_NAME
# =====================================================================

set -e  # Exit on error

PROJECT_ID="${1:-YOUR_PROJECT_ID}"
BUCKET_NAME="${2:-${PROJECT_ID}-profile-assets}"
REGION="asia-southeast2"  # Jakarta

echo ""
echo "================================================="
echo "  Profile App Deployment Script"
echo "  Project: $PROJECT_ID"
echo "  Bucket : $BUCKET_NAME"
echo "================================================="
echo ""

# ── Step 1: Set active project ─────────────────────
echo "[1/6] Setting GCP project..."
gcloud config set project "$PROJECT_ID"

# ── Step 2: Create GCS bucket ──────────────────────
echo "[2/6] Creating Cloud Storage bucket..."
if gsutil ls "gs://${BUCKET_NAME}" 2>/dev/null; then
  echo "  Bucket already exists, skipping creation."
else
  gsutil mb -l "$REGION" "gs://${BUCKET_NAME}"
  echo "  Bucket created: gs://${BUCKET_NAME}"
fi

# Make bucket publicly readable
gsutil iam ch allUsers:objectViewer "gs://${BUCKET_NAME}"
echo "  Bucket set to public read."

# ── Step 3: Upload images ──────────────────────────
echo "[3/6] Uploading images to Cloud Storage..."

for img in hero_banner.jpg skill_cloud.jpg skill_python.jpg bg_pattern.jpg education_badge.jpg; do
  if [ -f "$img" ]; then
    gsutil cp "$img" "gs://${BUCKET_NAME}/${img}"
    gsutil acl ch -u AllUsers:R "gs://${BUCKET_NAME}/${img}"
    echo "  Uploaded: $img -> https://storage.googleapis.com/${BUCKET_NAME}/${img}"
  else
    echo "  WARNING: $img not found, skipping."
  fi
done

# Handle profile photo separately (user may have their own)
if [ -f "profile_photo.jpg" ]; then
  gsutil cp "profile_photo.jpg" "gs://${BUCKET_NAME}/profile_photo.jpg"
  gsutil acl ch -u AllUsers:R "gs://${BUCKET_NAME}/profile_photo.jpg"
  echo "  Uploaded: profile_photo.jpg"
else
  echo "  INFO: profile_photo.jpg not found."
  echo "        Upload your own photo with:"
  echo "        gsutil cp YOUR_PHOTO.jpg gs://${BUCKET_NAME}/profile_photo.jpg"
fi

# ── Step 4: Replace bucket name in HTML/CSS ────────
echo "[4/6] Updating GCS URLs in HTML and CSS..."
sed -i.bak "s/YOUR_BUCKET_NAME/${BUCKET_NAME}/g" index.html style.css
echo "  URLs updated to use bucket: $BUCKET_NAME"

# ── Step 5: Enable required APIs ──────────────────
echo "[5/6] Enabling App Engine API..."
gcloud services enable appengine.googleapis.com --project="$PROJECT_ID" 2>/dev/null || true

# ── Step 6: Deploy to App Engine ──────────────────
echo "[6/6] Deploying to App Engine..."
gcloud app deploy app.yaml --project="$PROJECT_ID" --quiet

# ── Get deployed URL ───────────────────────────────
APP_URL=$(gcloud app describe --project="$PROJECT_ID" --format="value(defaultHostname)" 2>/dev/null)
FULL_URL="https://${APP_URL}"

echo ""
echo "================================================="
echo "  DEPLOYMENT SUCCESSFUL!"
echo "  App URL: $FULL_URL"
echo "================================================="

# Update url.txt
echo "$FULL_URL" > url.txt
echo "  url.txt updated with: $FULL_URL"
echo ""
echo "Next steps:"
echo "  1. Open $FULL_URL to verify your app"
echo "  2. Upload your profile photo if not done yet"
echo "  3. Edit index.html to add your real name, bio, and links"
echo "  4. Re-deploy: gcloud app deploy --quiet"
