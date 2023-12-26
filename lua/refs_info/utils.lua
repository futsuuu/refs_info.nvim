local M = {}

---@param buf buffer
---@param method string
function M.support_method(buf, method)
  for _, client in ipairs(vim.lsp.get_clients { bufnr = buf }) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

---Handler of vim.lsp.buf_request_all
---@param callback fun(results: any[])
function M.get_all_results(callback)
  ---@param results table<integer, { error: lsp.ResponseError, result: any }>
  return function(results)
    local ret = {}
    for _, result in pairs(results) do
      table.insert(ret, result.result)
    end
    callback(ret)
  end
end

---@param array any[]
---@param run_depth? integer
---@return any[]
function M.flatten(array, run_depth)
  local function flatten_list(arr, max_depth, current_depth)
    if type(arr) ~= 'table' or current_depth > max_depth then
      return { arr }
    end

    local result = {}
    for _, item in ipairs(arr) do
      local flat_item = flatten_list(item, max_depth, current_depth + 1)
      for _, sub_item in ipairs(flat_item) do
        table.insert(result, sub_item)
      end
    end

    return result
  end

  return flatten_list(array, run_depth or math.huge, 0)
end

return M
