$script:todoList = New-Object System.Collections.ArrayList

function Add-ToDo {
    param(
        [string]$item
    )
    $script:todoList.Add($item) | Out-Null
}

function Remove-ToDo {
    param([int]$index)
    if ($index -ge 0 -and $index -lt $script:todoList.Count) {
        $script:todoList.RemoveAt($index)
    } else {
        Write-Host "Invalid index. Please provide an index between 0 and $($script:todoList.Count - 1)."
    }
}

function Get-ToDos {
    for ($i = 0; $i -lt $script:todoList.Count; $i++) {
        "$($i): $($script:todoList[$i])"
    }
}

function Clear-ToDos {
    $script:todoList.Clear()
}

function Save-ToDos {
    param([string]$filename)
    $script:todoList | Out-File -FilePath $filename
}

function Import-ToDos {
    param([string]$filename)
    $content = Get-Content -Path $filename
    if ($content -is [System.Array]) {
        $script:todoList = New-Object System.Collections.ArrayList
        $content | ForEach-Object {
            $script:todoList.Add($_) | Out-Null
        }
    } else {
        Write-Host "Invalid file content. Please provide a valid to-do list file."
    }
}

function Add-MultipleToDos {
    param(
        [string[]]$items
    )
    $items | ForEach-Object {
        $script:todoList.Add($_) | Out-Null
    }
}

function Show-ToDoHelp {
    "Available commands:"
    "Add-ToDo '<item>'           - Add a to-do item (enclose item in quotes)"
    "Add-MultipleToDos '<item1>', '<item2>' - Add multiple to-do items (enclose items in quotes)"
    "Remove-ToDo <index>         - Remove a to-do item by index"
    "Get-ToDos                   - Show all to-do items"
    "Clear-ToDos                 - Clear all to-do items"
    "Save-ToDos '<filename>'     - Save to-do list to a file"
    "Import-ToDos '<filename>'   - Import to-do list from a file"
}
