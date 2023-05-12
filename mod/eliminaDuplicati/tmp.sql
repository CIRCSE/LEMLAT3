   SELECT DISTINCT t.*
   FROM (
        SELECT T.*,
               ls.gen ls_gen, clem, si, smv, spf, les, codles, lem, piu, ls.codlem ls_codlem, type, codLE, pt, a_gra, gra_u
        FROM throw T INNER JOIN lessario ls USING(n_id) WHERE lemma='abscedo'
    ) t LEFT JOIN (
        SELECT K.*,
        ls.gen ls_gen, clem, si, smv, spf, les, codles, lem, piu, ls.codlem ls_codlem, type, codLE, pt, a_gra, gra_u
        FROM keep K INNER JOIN lessario ls USING(n_id) WHERE lemma='abscedo'
    ) k ON k.lemma=t.lemma AND k.codlem=t.codlem AND k.gen=t.gen AND k.codmorf=t.codmorf
              AND k.ls_gen=t.ls_gen
              -- AND k.clem=t.clem
              AND (k.clem=t.clem OR k.clem='v' AND t.clem='' OR k.clem='' AND t.clem='v'
                   -- OR k.clem='v' AND k.codlem='V3' AND k.lemma REGEXP '.+o$' NOTA è compresa in:
                   OR k.codlem REGEXP '^V.+' 
                  )
              AND k.si=t.si
              -- AND k.smv=t.smv
              AND ( k.smv=t.smv
                   OR k.codlem REGEXP '^V.+' 
                   )
              AND k.spf=t.spf AND k.les=t.les
              -- AND k.codles=t.codles
              AND (k.codles=t.codles
                   OR
                     k.codles='n31' AND t.codles='n3' AND k.codlem='N3B' AND k.lemma REGEXP '.+(io|tas|or)$'
                   OR
                     k.codles REGEXP '^v.*[ri]$' AND t.codles REGEXP '^v.*[ri]$'
                     AND SUBSTRING(k.codles, 2, LENGTH(k.codles)-2)=SUBSTRING(t.codles, 2, LENGTH(t.codles)-2) 
                   OR
                     k.codles='n31' AND t.codles IN ('n3','n3p') AND k.codlem='N3B' AND k.lemma REGEXP '.+(o|x)$'
                   OR
                     k.codles='n3n1' AND t.codles IN ('n3n','n3p') AND k.codlem='N3B' AND k.lemma REGEXP '.+(n|a|us)$'
                   OR
                     k.codles='n3n2' AND t.codles IN ('n3n','n3p') AND k.codlem='N3B' AND k.lemma REGEXP '.+e$'
                   OR
                     k.codles='n2e' AND t.codles ='n2' AND k.codlem='N3B' AND k.lemma REGEXP '.+us$'
                   OR
                     k.codles IN ('n31', 'n32') AND t.codles IN ('n3n','n3p') AND k.codlem='N3B' AND k.lemma REGEXP '.+is$'
                   OR
                     k.codles ='n1e' AND t.codles ='n1' AND k.codlem='N1' AND k.lemma REGEXP '.+a$'
                  )   
              AND (k.lem=t.lem
                   OR k.lem<>'' AND t.lem='' AND k.codlem='N2/1' AND k.lemma REGEXP '.+us$'
                   OR k.lem<>'' AND t.lem='' AND k.codlem='N1' AND k.lemma REGEXP '.+a$'
                 ) 
              -- AND k.piu=t.piu
              AND k.ls_codlem=t.ls_codlem AND k.type=t.type AND k.codLE=t.codLE AND k.pt=t.pt
              -- AND k.a_gra=t.a_gra
              AND (k.a_gra=t.a_gra OR t.a_gra=''
                  OR k.a_gra<>'' AND t.a_gra='' AND k.codlem='N2/1' AND k.lemma REGEXP '.+us$'
                  OR k.a_gra<>'' AND t.a_gra='' AND k.codlem='N1' AND k.lemma REGEXP '.+a$'
                  )
              AND k.gra_u=t.gra_u              
    WHERE k.lemma IS NULL
;
