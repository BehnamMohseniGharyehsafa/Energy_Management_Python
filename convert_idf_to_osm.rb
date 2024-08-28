require 'openstudio'

def convert_idf_to_osm(idf_path)
  # Load the IDF file directly
  idf_file = OpenStudio::IdfFile.load(OpenStudio::Path.new(idf_path))
  
  if idf_file.empty?
    raise 'Failed to load IDF file.'
  end
  
  # Create the workspace from the IDF file
  workspace = OpenStudio::Workspace.new(idf_file.get)
  
  # Translate the Workspace to an OpenStudio Model (OSM)
  reverse_translator = OpenStudio::EnergyPlus::ReverseTranslator.new
  model = reverse_translator.translateWorkspace(workspace)

  if model.getModelObjects.empty?
    raise 'Model translation from IDF to OSM failed or resulted in an empty model.'
  end
  
  model
end

# Main execution
idf_path = ARGV[0]
osm_output_path = ARGV[1]

model = convert_idf_to_osm(idf_path)

# Save the OSM model to the specified path
success = model.save(OpenStudio::Path.new(osm_output_path), true)

if success
  puts "Successfully converted IDF to OSM and saved to: #{osm_output_path}"
else
  raise 'Failed to save the OSM file.'
end
