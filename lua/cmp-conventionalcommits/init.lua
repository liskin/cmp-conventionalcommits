local source = {}

local typesDict = {}
typesDict['build'] = {
  label = 'build',
  documentation = 'Changes that affect the build system or external dependencies',
}
typesDict['chore'] = {
  label = 'chore',
  documentation = 'Other changes that dont modify src or test files',
}
typesDict['ci'] = {
  label = 'ci',
  documentation = 'Changes to our CI configuration files and scripts',
}
typesDict['docs'] = {
  label = 'docs',
  documentation = 'Documentation only changes',
}
typesDict['feat'] = {
    label = 'feat',
    documentation = 'A new feature'
}
typesDict['fix'] = {
    label = 'fix',
    documentation = 'A bug fix'
}
typesDict['perf'] = {
  label = 'perf',
  documentation = 'A code change that improves performance',
}
typesDict['refactor'] = {
  label = 'refactor',
  documentation = 'A code change that neither fixes a bug nor adds a feature',
}
typesDict['revert'] = {
  label = 'revert',
  documentation = 'Reverts a previous commit',
}
typesDict['style'] = {
  label = 'style',
  documentation = 'Changes that do not affect the meaning of the code',
}
typesDict['test'] = {
  label = 'test',
  documentation = 'Adding missing tests or correcting existing tests',
}

function source.new()
    source.types = {
      typesDict['build'], typesDict['chore'], typesDict['ci'],
      typesDict['docs'], typesDict['feat'], typesDict['fix'], typesDict['perf'],
      typesDict['refactor'], typesDict['revert'], typesDict['style'],
      typesDict['test'],
    }

  return setmetatable({}, {__index = source})
end

function source:is_available() return vim.bo.filetype == "gitcommit" end

function source:get_keyword_pattern() return [[\w\+]] end

local function candidates(entries)
  local items = {}
  for _, v in ipairs(entries) do
    table.insert(items, {
      label = v.label,
      kind = require('cmp').lsp.CompletionItemKind.Keyword,
      insertText = v.label .. ": ",
      documentation = v.documentation,
    })
    table.insert(items, {
      label = v.label .. "!",
      kind = require('cmp').lsp.CompletionItemKind.Keyword,
      insertText = v.label .. "!: ",
      documentation = "(breaking change)\n" .. v.documentation,
    })
    table.insert(items, {
      label = v.label .. "(…)",
      kind = require('cmp').lsp.CompletionItemKind.Snippet,
      insertText = v.label .. "($0): ",
      insertTextFormat = require('cmp').lsp.InsertTextFormat.Snippet,
      documentation = "(scoped)\n" .. v.documentation,
    })
    table.insert(items, {
      label = v.label .. "(…)!",
      kind = require('cmp').lsp.CompletionItemKind.Snippet,
      insertText = v.label .. "($0)!: ",
      insertTextFormat = require('cmp').lsp.InsertTextFormat.Snippet,
      documentation = "(breaking change, scoped)\n" .. v.documentation,
    })
  end
  return items
end

function source:complete(request, callback)
  if request.context.option.reason == "manual" and request.context.cursor.row ==
      1 and request.context.cursor.col >= 1 and not request.context.cursor_before_line:find(" ") then
    callback({items = candidates(self.types), isIncomplete = true})
  elseif request.context.option.reason == "auto" and request.context.cursor.row ==
      1 and request.context.cursor.col == 2 then
    callback({items = candidates(self.types), isIncomplete = true})
  else
    callback()
  end
end

return source
