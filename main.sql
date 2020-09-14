CREATE TABLE directories (
  id VARCHAR (32),
  name VARCHAR (255),
  PRIMARY KEY (id)
);

CREATE TABLE files (
  id VARCHAR (32),
  name VARCHAR (255),
  directory_id VARCHAR (32),
  PRIMARY KEY (id),
  FOREIGN KEY (directory_id) REFERENCES directories (id)
);

CREATE TABLE directory_paths (
  child_id        VARCHAR(32),
  ancestor_id     VARCHAR(32),
  depth_offset INTEGER NOT NULL,
  FOREIGN KEY (child_id) REFERENCES directories (id),
  FOREIGN KEY (ancestor_id) REFERENCES directories (id)
);

/*
以下のような階層構造を表現する
a ┬ b
  └ c ┬ d
      └ e ─ f
*/

-- 新規ディレクトリ作成
INSERT INTO directories (id, name) VALUES ('a', 'a');
-- 自己参照を追加
INSERT INTO directory_paths (child_id, ancestor_id, depth_offset) VALUES ('a', 'a', 0);

-- ディレクトリ取得
SELECT * FROM directories AS d JOIN directory_paths AS dp ON d.id = dp.ancestor_id WHERE dp.ancestor_id = 'a';

/* aディレクトリにbディレクトリを追加する */
INSERT INTO directories (id, name) VALUES ('b', 'b');
-- 自己参照を追加
INSERT INTO directory_paths (child_id, ancestor_id, depth_offset) VALUES ('b', 'b', 0);
-- aディレクトリを子孫として持つディレクトリをbの先祖に追加しdepthを+1する
INSERT INTO directory_paths (child_id, ancestor_id, depth_offset) VALUES ('b', 'a', 1); -- depthは取得結果を+1した値

/* aディレクトリにcディレクトリを追加する */
INSERT INTO directories (id, name) VALUES ('c', 'c');
-- 自己参照を追加
INSERT INTO directory_paths (child_id, ancestor_id, depth_offset) VALUES ('c', 'c', 0);
-- aディレクトリを子孫として持つディレクトリをcの先祖に追加しdepthを+1する
INSERT INTO directory_paths (child_id, ancestor_id, depth_offset) VALUES ('c', 'a', 1); -- depthは取得結果を+1した値

/* cディレクトリにdディレクトリとeディレクトリを追加する */
INSERT INTO directories (id, name) VALUES ('d', 'd');
-- 自己参照を追加
INSERT INTO directory_paths (child_id, ancestor_id, depth_offset) VALUES ('d', 'd', 0);
-- cディレクトリを子孫として持つディレクトリをdの先祖に追加しdepthを+1
INSERT INTO directory_paths (child_id, ancestor_id, depth_offset) VALUES ('d', 'c', 1); -- depthは取得結果を+1した値
INSERT INTO directory_paths (child_id, ancestor_id, depth_offset) VALUES ('d', 'a', 2); -- depthは取得結果を+1した値

INSERT INTO directories (id, name) VALUES ('e', 'e');
-- 自己参照を追加
INSERT INTO directory_paths (child_id, ancestor_id, depth_offset) VALUES ('e', 'e', 0);
-- cディレクトリを子孫として持つディレクトリをeの先祖に追加しdepthを+1
INSERT INTO directory_paths (child_id, ancestor_id, depth_offset) VALUES ('e', 'c', 1); -- depthは取得結果を+1した値
INSERT INTO directory_paths (child_id, ancestor_id, depth_offset) VALUES ('e', 'a', 2); -- depthは取得結果を+1した値


/* eディレクトリにfディレクトリを追加する */
INSERT INTO directories (id, name) VALUES ('f', 'f');
-- 自己参照を追加
INSERT INTO directory_paths (child_id, ancestor_id, depth_offset) VALUES ('f', 'f', 0);
-- eディレクトリを子孫として持つディレクトリをfの先祖に追加しdepthを+1
INSERT INTO directory_paths (child_id, ancestor_id, depth_offset) VALUES ('f', 'e', 1); -- depthは取得結果を+1した値
INSERT INTO directory_paths (child_id, ancestor_id, depth_offset) VALUES ('f', 'c', 2); -- depthは取得結果を+1した値
INSERT INTO directory_paths (child_id, ancestor_id, depth_offset) VALUES ('f', 'a', 3); -- depthは取得結果を+1した値

/* cのツリーを削除する */
-- SELECT child_id FROM directory_paths WHERE ancestor_id = 'c'; した結果をIN句にわたす
DELETE FROM directory_paths WHERE child_id IN ('c', 'd', 'e', 'f');


-- bディレクトリの中身を取得
SELECT * FROM directories AS d JOIN directory_paths AS dp ON d.id = dp.ancestor_id WHERE dp.ancestor_id = 'b' AND depth_offset = 1;
