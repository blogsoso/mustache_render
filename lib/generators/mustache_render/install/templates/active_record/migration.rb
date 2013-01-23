# -*- encoding : utf-8 -*-
class MustacheRenderMigration < ActiveRecord::Migration
  def self.up
    create_table :mustache_render_folders, :options => 'DEFAULT CHARSET=utf8' do |t|
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

    create_table :mustache_render_templates, :options => 'DEFAULT CHARSET=utf8' do |t|
      t.integer :last_user_id                # 最后一个修改模板的用户
      t.integer :create_user_id              # 创建者的用户id
      t.integer :folder_id                   # 文件夹的ID
      t.string  :name                        # 模板的名称
      t.text    :content                     # 代码

      t.text    :note                        # 备注
      t.timestamps
    end

    create_table :mustache_render_template_versions, :options => 'DEFAULT CHARSET=utf8' do |t|
      t.integer :template_id                 # 模板的id
      t.integer :last_user_id                # 最后一个修改模板的用户
      t.integer :create_user_id              # 创建者的用户id
      t.integer :folder_id                   # 文件夹的ID
      t.string  :name                        # 模板的名称
      t.text    :content                     # 代码
      t.string  :full_path
      t.string  :change_log                  # 修改日志

      t.text    :note                        # 备注
      t.timestamps
    end

    create_table :mustache_render_managers, :options => 'DEFAULT CHARSET=utf8' do |t|
      t.integer :user_id

      t.integer :admin_able # 是否是管理权限
      t.integer :edit_able  # 是否可以编辑

      t.timestamps
    end

  end

  def self.down
    drop_table :mustache_render_folders
    drop_table :mustache_render_template_versions
    drop_table :mustache_render_templates
    drop_table :mustache_render_managers
  end
end

