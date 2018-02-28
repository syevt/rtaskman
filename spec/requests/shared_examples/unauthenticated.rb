shared_examples 'unauthenticated' do |verb, path, id|
  it "returns 'unauthenticated' error when not logged in" do
    send(verb, id ? send(path, id) : send(path))
    expect(response.status).to eq(401)
    expect(json[:errors].first).to eq(t('devise.failure.unauthenticated'))
  end
end
