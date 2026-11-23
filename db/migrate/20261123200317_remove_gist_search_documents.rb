class RemoveGistSearchDocuments < ActiveRecord::Migration[8.1]
  # The gists tables were dropped in 20191121163840 but their pg_search
  # documents were left behind; matching one in search raised a NameError
  # because the Gist/GistFile models no longer exist.
  def up
    execute <<~SQL
      DELETE FROM pg_search_documents WHERE searchable_type IN ('Gist', 'GistFile')
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
