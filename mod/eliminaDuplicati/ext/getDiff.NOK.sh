
cat checkLemlat.tsv | grep -w NO | cut -f 6 > L1.NO.txt
cat checkLemlat.tsv | grep -w NO | cut -f 8 > L2.NO.txt

#git diff --no-index --word-diff=plain --word-diff-regex=.  L1.txt L2.txt > L1_L2.txt
rm -f L1_L2.NO.txt
N=$(cat L1.NO.txt| wc -l);
for l in $(seq 1 $N); do
    sed -n "${l}p" L1.NO.txt > l1.txt
    sed -n "${l}p" L2.NO.txt > l2.txt
    git diff --no-index --word-diff=plain --word-diff-regex=.  l1.txt l2.txt | tail -n1 >> L1_L2.NO.txt
done 

cat L1_L2.NO.txt | \
grep -oE "([a-z])?\[-[a-z]+-\]([a-z])?\{\+[a-z]+\+\}([a-z])?|([a-z])?\[-[a-z]+-\]([a-z])?|([a-z])?\{\+[a-z]+\+\}([a-z])?" | \
sort | uniq -c | sed -E 's/^ +//' | sort -nr  | sed -E 's/^([0-9]+) (.+)/\2\t\1/' > diffDstr.NO.tsv


cat checkLemlat.tsv | grep -w OK | cut -f 6 > L1.OK.txt
cat checkLemlat.tsv | grep -w OK | cut -f 8 > L2.OK.txt

#git diff --no-index --word-diff=plain --word-diff-regex=.  L1.txt L2.txt > L1_L2.txt
rm -f L1_L2.OK.txt
N=$(cat L1.OK.txt| wc -l);
for l in $(seq 1 $N); do
    sed -n "${l}p" L1.OK.txt > l1.txt
    sed -n "${l}p" L2.OK.txt > l2.txt
    git diff --no-index --word-diff=plain --word-diff-regex=.  l1.txt l2.txt | tail -n1 >> L1_L2.OK.txt
done 

rm -f l1.txt l2.txt

cat L1_L2.OK.txt | \
grep -oE "([a-z])?\[-[a-z]+-\]([a-z])?\{\+[a-z]+\+\}([a-z])?|([a-z])?\[-[a-z]+-\]([a-z])?|([a-z])?\{\+[a-z]+\+\}([a-z])?" | \
sort | uniq -c | sed -E 's/^ +//' | sort -nr  | sed -E 's/^([0-9]+) (.+)/\2\t\1/' > diffDstr.OK.tsv
