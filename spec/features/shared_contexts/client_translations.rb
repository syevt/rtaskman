shared_context 'client translations' do
  given(:translations) do
    JSON.parse(File.read(Rails.root.join('public/languages/en.json')))
  end
end
