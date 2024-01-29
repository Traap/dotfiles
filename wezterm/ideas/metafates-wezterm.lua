local utils = require 'utils'

require('status').enable()

local modules = utils.map({
  'window',
  'pane',
  'font',
  'theme',
  'tab',
  'keys',
}, utils.req)

return utils.merge(table.unpack(modules))
