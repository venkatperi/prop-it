errors = require 'common-errors'

module.exports = ( obj, opts ) ->
  throw new errors.ArgumentNullError 'obj' unless arguments.length is 2
  opts = {} unless opts?
  name = opts.name or throw new MissingOptionError name : 'name'
  throw new ItemExistsError name : name if obj[ name ]?

  store = opts.store or obj
  field = opts.field or if store is obj then "_#{name}" else name
  convert = opts.convert or ( v ) -> v
  getter = opts.getter or -> store[ field ]
  setter = opts.setter or ( v ) -> store[ field ] = v

  obj[ name ] = ( value ) ->
    if opts.readonly && arguments.length > 0
      throw new errors.NotPermitted "'#{name}' is readonly."

    return v = getter() if arguments.length is 0

    value = convert value
    if v != value
      setter value
      obj.emit "changed:#{name}", value, v if typeof obj.emit is 'function'

  if opts.readonly
    throw errors.ArgumentNullError 'initial' unless opts.initial?
    setter convert( opts.initial )
  else
    obj[ name ] opts.initial if opts.initial?

  obj
