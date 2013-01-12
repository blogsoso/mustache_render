# -*- encoding : utf-8 -*-
class MustacheRenderMigration < ActiveRecord::Migration
  def self.up
    create_table :mustache_render_folders do |t|
      t.string :name,      :default => ''    # 文件夹的名称

      t.string :full_path, :default => ''    # 全路径

      ###### for nested_ful #####################
      t.integer :parent_id                   # 父节点的id
      t.integer :left_id
      t.integer :right_id
      t.integer :depth                       # 深度
      t.integer :children_count, :default => 0
      ###########################################

      t.text    :note                        # 备注

      t.timestamps
    end

    create_table :mustache_render_templates do |t|
      t.integer :folder_id                   # 文件夹的ID
      t.string  :name                        # 模板的名称
      t.text    :content                     # 代码

      t.text    :note                        # 备注
      t.timestamps
    end

    create_table :mustache_render_managers do |t|
      t.integer  :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :mustache_render_folders
    drop_table :mustache_render_templates
    drop_table :mustache_render_managers
  end
end

