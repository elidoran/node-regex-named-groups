assert       = require 'assert'
captureNames = require '../../lib'

describe 'test no match', ->

  it 'should return null', ->
    result = captureNames(/blah/, ['name1']).exec 'no match'
    assert.equal result, null

describe 'test matching', ->

  for test in [
    {
      desc:'single group', should:'find group'
      rex:/(group)/, names:['group'], string:'group'
      result:{group:'group'}
    }
    {
      desc:'single group within string', should:'find group'
      rex:/(group)/, names:['group'], string:'some group thing'
      result:{group:'group'}
    }
    {
      desc:'single group within both regex and string', should:'find group'
      rex:/some (group) thing/, names:['group'], string:'some group thing'
      result:{group:'group'}
    }

    {
      desc:'multiple groups',should:'find all groups'
      rex:/(1) s (22) s (333)/, names:['g1','g2','g3'], string:'1 s 22 s 333'
      result:{g1:'1',g2:'22',g3:'333'}
    }
    {
      desc:'multiple groups within string', should:'find all groups'
      rex:/(1) s (22) s (333)/, names:['g1','g2','g3'], string:'some 1 s 22 s 333 thing'
      result:{g1:'1',g2:'22',g3:'333'}
    }
    {
      desc:'multiple groups with ignored top-level group', should:'find all groups'
      rex:/(1) s (22) (?:blah) s (333)/, names:['g1','g2','g3'],string:'some 1 s 22 blah s 333 thing'
      result:{g1:'1',g2:'22',g3:'333'}
    }
    {
      desc:'multiple groups with ignored internal group', should:'find all groups'
      rex:/(1) s (22) s ((?:33)3)/, names:['g1','g2','g3'], string:'some 1 s 22 s 333 thing'
      result:{g1:'1',g2:'22',g3:'333'}
    }
    {
      desc:'multiple matches by single capture group',should:'return last group'
      rex:/(\d+)(?:\s(\d+))*/,names:['g1','g2'],string:'some 1 22 333 thing'
      result:{g1:'1',g2:'333'},array:true, options:{preserve:true}
    }

    {
      desc:'single group', should:'find group'
      rex:/(group)/, names:['group'],string:'group'
      result:{group:'group'},array:true, options:{preserve:true}
    }
    {
      desc:'single group within string', should:'find group'
      rex:/(group)/, names:['group'], string:'some group thing'
      result:{group:'group'},array:true, options:{preserve:true}
    }
    {
      desc:'single group within both regex and string', should:'find group'
      rex:/some (group) thing/, names:['group'], string:'some group thing'
      result:{group:'group'},array:true, options:{preserve:true}
    }

    {
      desc:'multiple groups', should:'find all groups'
      rex:/(1) s (22) s (333)/, names:['g1','g2','g3'], string:'1 s 22 s 333'
      result:{g1:'1',g2:'22',g3:'333'}, array:true, options:{preserve:true}
    }
    {
      desc:'multiple groups within string', should:'find all groups'
      rex:/(1) s (22) s (333)/, names:['g1','g2','g3'], string:'some 1 s 22 s 333 thing'
      result:{g1:'1',g2:'22',g3:'333'}, array:true, options:{preserve:true}
    }
  ]
    do (test) ->
      describe test.desc, -> it test.should, ->
        result = captureNames(test.rex, test.names, test.options).exec test.string
        assert result, 'should produce a result'
        assert.equal result.$array?, test.array?
        for key,value of test.result
          assert.equal result[key], value,
            "result[#{key}] should be '#{value}' but is '#{result[key]}'"
