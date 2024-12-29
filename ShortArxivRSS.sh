# repository path
REPO="$HOME/short_arxiv_rss"


BASE_URL="https://rss.arxiv.org/rss"
DOWNLOAD_FILE="${REPO}/raw_arxiv.rss"
OUTPUT_FILE="${REPO}/filtered_arxiv.rss"

# for example filter quantum machine learning, use quant-ph as the main branch
LINK_SUFFIX="quant-ph"
# Define the categories to filter
CATEGORIES=("cs.AI" "cs.LG" "stat.ML" "cs.CC" "cs.IT")
# Construct the category list
CATEGORY_FILTER=""
for CATEGORY in "${CATEGORIES[@]}"; do
    CATEGORY_FILTER+=" or category='$CATEGORY'"
done
CATEGORY_FILTER="${CATEGORY_FILTER:4}"  # Remove the leading ' or '

# download the rss file
curl -s "$BASE_URL/$LINK_SUFFIX" -o $DOWNLOAD_FILE
# delete the replace paper
xmlstarlet ed -d "//item[count(category)!=1 and not($CATEGORY_FILTER) or (arxiv:announce_type='replace') or (arxiv:announce_type='replace-cross')]" $DOWNLOAD_FILE > $OUTPUT_FILE

echo "Today's date: $(date)"
ORIGIN_ITEM_COUNT=$(xmlstarlet sel -t -v "count(//item)" $DOWNLOAD_FILE)
ITEM_COUNT=$(xmlstarlet sel -t -v "count(//item)" $OUTPUT_FILE)
echo "Number of total items: $ORIGIN_ITEM_COUNT"
echo "Number of items left: $ITEM_COUNT"

#
cd ${REPO}
# comit add push to github page
git add --all
git commit -m "Update $(date)"
git push origin

