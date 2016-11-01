SELECT
  month,
  good_faith,
  anon_reverted,
  SUM(reverted_edits) AS reverted_edits,
  SUM(reverts) AS reverts
FROM (
  SELECT
    LEFT(rev_timestamp, 6) AS month, 
    rev_comment LIKE "%WP:AGF%" AS good_faith,
    (
      rev_comment RLIKE ".*\\[\\[Special:Contributions/[0-9\\.]+\\|.*" OR
      rev_comment RLIKE ".*\\[\\[Special:Contributions/([0-9A-F]{1,4}\\:){7}[0-9A-F]{1,4}\\|.*"
    ) AS anon_reverted,
    SUM(CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(rev_comment, " ", 2), " ", -1) AS INT)) AS reverted_edits,
    COUNT(*) AS reverts
  FROM revision 
  WHERE 
    rev_comment LIKE "Reverted%STiki%"
  GROUP BY 1,2,3
  UNION ALL
  SELECT
    LEFT(ar_timestamp, 6) AS month,
    ar_comment LIKE "%WP:AGF%" AS good_faith,
    (
      ar_comment RLIKE ".*\\[\\[Special:Contributions/[0-9\\.]+\\|.*" OR
      ar_comment RLIKE ".*\\[\\[Special:Contributions/([0-9A-F]{1,4}\\:){7}[0-9A-F]{1,4}\\|.*"
    ) AS anon_reverted, 
    SUM(CAST(SUBSTRING_INDEX(SUBSTRING_INDEX(ar_comment, " ", 2), " ", -1) AS INT)) AS reverted_edits,
    COUNT(*) AS reverts
  FROM archive
  WHERE
    ar_comment LIKE "Reverted%STiki%"
  GROUP BY 1,2,3
) AS revert_activity
GROUP BY 1,2,3;
