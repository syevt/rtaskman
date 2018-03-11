describe 'Fake suite one', ->
  it 'tests bool correctly', ->
    expect(on).to.be.true

  it 'tests bool incorrectly', ->
    expect(on).to.be.false

  it 'tests integer correctly', ->
    expect(2 + 2).to.eq(4)

  it 'tests integer incorrectly', ->
    expect(2 + 2).to.eq(5)
