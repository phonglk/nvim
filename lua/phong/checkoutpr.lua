local function get_open_prs()
  local handle = io.popen("gh pr list --author @me --json number,title,headRefName")
  local result = handle:read("*a")
  handle:close()
  
  local prs = {}
  local decoded = vim.json.decode(result)
  for _, pr in ipairs(decoded) do
    local formatted_line = string.format("#%-4d  │  %-50s  │  %s", 
      pr.number,
      pr.title:sub(1, 50),
      pr.headRefName
    )
    table.insert(prs, formatted_line)
  end
  return prs
end

local function checkout_pr(pr_number)
  local cmd = string.format("gh pr checkout %s", pr_number)
  print("Executing command: " .. cmd)
  os.execute(cmd)
end

local function extract_pr_number(pr_line)
  -- PR lines from gh typically look like: "#123    PR title    status"
  return pr_line:match("#(%d+)")
end

local function list_and_checkout_pr()
  local prs = get_open_prs()
  
  if #prs == 0 then
    print("No open PRs found")
    return
  end
  
  require("fzf-lua").fzf_exec(
    prs,
    {
      prompt = "Select PR to checkout> ",
      actions = {
        ["default"] = function(selected)
          local pr_line = selected[1]
          local pr_number = extract_pr_number(pr_line)
          if pr_number then
            checkout_pr(pr_number)
          else
            print("Could not extract PR number")
          end
        end
      }
    }
  )
end

-- Create Vim command
vim.api.nvim_create_user_command('CheckoutPR', function()
  list_and_checkout_pr()
end, {})
