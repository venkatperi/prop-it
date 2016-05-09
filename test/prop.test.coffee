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

  it "throws on missing args", ( done ) ->
    ( -> prop obj).should.throw
    done()

  it "throws if property name is missing", ( done ) ->
    ( -> prop obj, {}).should.throw
    done()

  it "field name is prefixed with '_'", ( done ) ->
    prop obj, { name : 'foo', initial : 1 }
    should(obj._foo).exist
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

  it "read only must have an initial value", ( done ) ->
    ( -> prop obj, { name : 'foo', readonly : true }).should.throw
    done()

  it "throws if assigning a read only", ( done ) ->
    prop obj, { name : 'foo', initial : 123, readonly : true }
    ( -> obj.foo "abc").should.throw
    obj.foo().should.equal 123
    done()


