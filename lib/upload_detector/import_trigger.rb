require 'digest/sha1'

UploadReference = Struct.new(:account, :uploaded_at, :files) do
  def id
    "#{account}-#{uploaded_at.to_i}-#{short_file_digest}"
  end
  def short_file_digest
    file_digest[0,8]
  end
  def file_digest
    Digest::SHA1.hexdigest files.join
  end
end

# TODO: make it run in parallel later with celluloid
class ImportTrigger
  attr_reader :import_store, :import_runner, :root_import_path
  def initialize args={}
    @import_store  = args[:store] || ImportStore.new(location: args[:pstore_file])
    @import_runner = args[:import_runner] || ImportRunner.new(args)
    @root_import_path = args[:root_import_path]
  end

  def trigger_import
    import = import_store.find_or_create_import( import_attrs )

    unless import.run?
      import_runner.run import

      if import.success?
        import.save
      end
    else
      # Import did already run. Do nothing.
    end
  end

  # callbacks
  def on_files_uploaded args
    @account        = args[:account]
    @uploaded_at    = args[:uploaded_at]
    @uploaded_files = args[:uploaded_files]
    trigger_import
  end


  def upload_reference
    UploadReference.new(@account, @uploaded_at, @uploaded_files).id
  end

  def import_attrs
    { :upload_reference => upload_reference, :files => absolute_path_uploaded_files }
  end

  def absolute_path_uploaded_files
    @uploaded_files.map{ |file| File.join root_import_path, @account, file }
  end
end


