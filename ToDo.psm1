$script:todoList = New-Object System.Collections.ArrayList

function Add-ToDo {
    param(
        [string]$item
    )
    $script:todoList.Add($item) | Out-Null
}


function Remove-ToDo {
    param([int]$index)
    $script:todoList.RemoveAt($index)
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
    $script:todoList = Get-Content -Path $filename
}

function Add-MultipleToDos {
    param(
        [string[]]$items
    )
    $items | ForEach-Object {
        $script:todoList.Add($_) | Out-Null
    }
}

function Show-Help {
    "Available commands:"
    "Add-ToDo '<item>'           - Add a to-do item (enclose item in quotes)"
    "Add-MultipleToDos '<item1>', '<item2>' - Add multiple to-do items (enclose each item in quotes)"
    "Remove-ToDo <index>         - Remove a to-do item by index"
    "Get-ToDos                   - Get all to-do items"
    "Clear-ToDos                 - Clear all to-do items"
    "Save-ToDos <filename>       - Save to-do list to a file"
    "Import-ToDos <filename>     - Import to-do list from a file"
}

Export-ModuleMember -Function Add-ToDo, Remove-ToDo, Get-ToDos, Clear-ToDos, Save-ToDos, Import-ToDos, Show-Help, Add-MultipleToDos