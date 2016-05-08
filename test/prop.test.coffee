should = require( "should" )
assert = require( "assert" )
prop = require '../index'

obj = {}

describe "prop", ->

  beforeEach ->
    obj = {}

  it "create a prop", ( done ) ->
    prop obj, { name : 'foo', initial : 1 }
    obj.foo.should.be.a.Function
    done()

  it "assigns initial value", ( done ) ->
    prop obj, { name : 'foo', initial : 1 }
    obj.foo().should.equal 1
    done()

  it "setter", ( done ) ->
    prop obj, { name : 'foo', initial : 1 }
    obj.foo "test"
    obj.foo().should.equal "test"
    done()

  it "custom getter", ( done ) ->
    prop obj, { name : 'foo', getter : -> "custom" }
    obj.foo 123
    obj.foo().should.equal "custom"
    done()

  it "custom setter", ( done ) ->
    prop obj,
      name : 'foo',
      setter : ( v ) ->
        v.should.equal "custom"
        done()

    obj.foo "custom"

  it "backing store", ( done ) ->
    store = { foo : "xyz" }
    prop obj, { name : 'foo', store : store }
    obj.foo 123
    store.foo.should.equal 123
    done()

  it "specify field name", ( done ) ->
    prop obj, { name : 'foo', field : 'xyz' }
    obj.foo 123
    obj.xyz.should.equal 123
    done()

  it "setter conversion function", ( done ) ->
    prop obj, { name : 'foo', convert : ( v ) -> v * 2 }
    obj.foo 123
    obj.foo().should.equal 123 * 2
    done()

  it "read only", ( done ) ->
    prop obj, { name : 'foo', initial : 123, readOnly : true }
    obj.foo "abc"
    obj.foo().should.equal 123
    done()


