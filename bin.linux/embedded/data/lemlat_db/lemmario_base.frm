TYPE=VIEW
query=select `lemlat_db`.`lemmario`.`id_lemma` AS `id_lemma`,`lemlat_db`.`lemmario`.`lemma` AS `lemma`,`lemlat_db`.`lemmario`.`codlem` AS `codlem`,`lemlat_db`.`lemmario`.`gen` AS `gen`,`lemlat_db`.`lemmario`.`codmorf` AS `codmorf`,`lemlat_db`.`lemmario`.`n_id` AS `n_id`,`lemlat_db`.`lemmario`.`lemma_reduced` AS `lemma_reduced`,`lemlat_db`.`lemmario`.`src` AS `src` from `lemlat_db`.`lemmario` where (`lemlat_db`.`lemmario`.`src` = \'B\')
md5=6ec1baf0d45633ca9e0594867b066653
updatable=1
algorithm=0
definer_user=passarotti
definer_host=%
suid=1
with_check_option=0
timestamp=2017-02-23 00:22:29
create-version=1
source=select `lemmario`.`id_lemma` AS `id_lemma`,`lemmario`.`lemma` AS `lemma`,`lemmario`.`codlem` AS `codlem`,`lemmario`.`gen` AS `gen`,`lemmario`.`codmorf` AS `codmorf`,`lemmario`.`n_id` AS `n_id`,`lemmario`.`lemma_reduced` AS `lemma_reduced`,`lemmario`.`src` AS `src` from `lemmario` where (`lemmario`.`src` = \'B\')
client_cs_name=utf8
connection_cl_name=utf8_general_ci
view_body_utf8=select `lemlat_db`.`lemmario`.`id_lemma` AS `id_lemma`,`lemlat_db`.`lemmario`.`lemma` AS `lemma`,`lemlat_db`.`lemmario`.`codlem` AS `codlem`,`lemlat_db`.`lemmario`.`gen` AS `gen`,`lemlat_db`.`lemmario`.`codmorf` AS `codmorf`,`lemlat_db`.`lemmario`.`n_id` AS `n_id`,`lemlat_db`.`lemmario`.`lemma_reduced` AS `lemma_reduced`,`lemlat_db`.`lemmario`.`src` AS `src` from `lemlat_db`.`lemmario` where (`lemlat_db`.`lemmario`.`src` = \'B\')
