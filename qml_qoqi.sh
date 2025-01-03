#!/bin/bash

# repo_PATHsitory path
REPO_PATH="$HOME/short_arxiv_rss"

ARXIV_RSS_BASE_URL="https://rss.arxiv.org/rss"
RSS_DOWNLOAD_FILE="${REPO_PATH}/raw_qml.rss"
RSS_OUTPUT_FILE="${REPO_PATH}/qml.rss"

# for example filter quantum machine learning, use quant-ph as the main branch
RSS_CATEGORY="quant-ph"
# Define the categories to filter
CATEGORIES=("cs.AI" "cs.LG" "stat.ML" "cs.CC" "cs.IT")
# Construct the category list
CATEGORY_FILTER=""
for CATEGORY in "${CATEGORIES[@]}"; do
    CATEGORY_FILTER+=" or category='$CATEGORY'"
done
CATEGORY_FILTER="${CATEGORY_FILTER:4}"  # Remove the leading ' or '

# download the rss file
curl -s "$ARXIV_RSS_BASE_URL/$RSS_CATEGORY" -o $RSS_DOWNLOAD_FILE
# delete the replace paper
xmlstarlet ed -d "//item[count(category)!=1 and not($CATEGORY_FILTER) or (arxiv:announce_type='replace') or (arxiv:announce_type='replace-cross')]" $RSS_DOWNLOAD_FILE > $RSS_OUTPUT_FILE

echo "Today's date: $(date), QML"
ORIGIN_ITEM_COUNT=$(xmlstarlet sel -t -v "count(//item)" $RSS_DOWNLOAD_FILE)
ITEM_COUNT=$(xmlstarlet sel -t -v "count(//item)" $RSS_OUTPUT_FILE)
echo "Number of total items: $ORIGIN_ITEM_COUNT"
echo "Number of items left: $ITEM_COUNT"


RSS_DOWNLOAD_FILE="${REPO_PATH}/raw_qoqi.rss"
RSS_OUTPUT_FILE="${REPO_PATH}/qoqi.rss"

# for example filter quantum machine learning, use quant-ph as the main branch
RSS_CATEGORY="quant-ph"
# Define the categories to filter
CATEGORIES=("physics.optics")
# Construct the category list
CATEGORY_FILTER=""
for CATEGORY in "${CATEGORIES[@]}"; do
    CATEGORY_FILTER+=" or category='$CATEGORY'"
done
CATEGORY_FILTER="${CATEGORY_FILTER:4}"  # Remove the leading ' or '

# download the rss file
curl -s "$ARXIV_RSS_BASE_URL/$RSS_CATEGORY" -o $RSS_DOWNLOAD_FILE
# delete the replace paper
xmlstarlet ed -d "//item[not($CATEGORY_FILTER) or (arxiv:announce_type='replace') or (arxiv:announce_type='replace-cross')]" $RSS_DOWNLOAD_FILE > $RSS_OUTPUT_FILE

echo "Today's date: $(date), QOQI"
ORIGIN_ITEM_COUNT=$(xmlstarlet sel -t -v "count(//item)" $RSS_DOWNLOAD_FILE)
ITEM_COUNT=$(xmlstarlet sel -t -v "count(//item)" $RSS_OUTPUT_FILE)
echo "Number of total items: $ORIGIN_ITEM_COUNT"
echo "Number of items left: $ITEM_COUNT"


cd ${REPO_PATH}
# comit add push to github page
git add --all
git commit -m "Update $(date)"
git push origin rss


