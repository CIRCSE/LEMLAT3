
cat groupsQuasi.soloLemma.tsv | tail -n+2 | cut -f3 | cut -f1 -d, > L1.txt
cat groupsQuasi.soloLemma.tsv | tail -n+2 | cut -f3 | cut -f2 -d, > L2.txt

#git diff --no-index --word-diff=plain --word-diff-regex=.  L1.txt L2.txt > L1_L2.txt
rm -f L1_L2.txt
N=$(cat L1.txt| wc -l);
for l in $(seq 1 $N); do
    sed -n "${l}p" L1.txt > l1.txt
    sed -n "${l}p" L2.txt > l2.txt
    git diff --no-index --word-diff=plain --word-diff-regex=.  l1.txt l2.txt | tail -n1 >> L1_L2.txt
done 

cat L1_L2.txt | grep -oE "([a-z])?\[-[a-z]+-\]([a-z])?\{\+[a-z]+\+\}([a-z])?|([a-z])?\[-[a-z]+-\]([a-z])?|([a-z])?\{\+[a-z]+\+\}([a-z])?" | sort | uniq -c | sed -E 's/^ +//' | sort -nr  | sed -E 's/^([0-9]+) (.+)/\2\t\1/' > diffDstr.tsv
