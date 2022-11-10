#!/usr/bin/env -S dotnet fsi

#r "nuget: Spectre.Console"

type AnsiConsole  = Spectre.Console.AnsiConsole
type Regex        = System.Text.RegularExpressions.Regex
type RegexOptions = System.Text.RegularExpressions.RegexOptions
type File         = System.IO.File

// Helper for Regex
let (|MatchIX|_|) regex input =
    let m = Regex.Match(input, regex, RegexOptions.IgnorePatternWhitespace ||| RegexOptions.IgnoreCase)
    if m.Success then
        Some (m.Groups |> Seq.fold (fun xs m->
            m.Value :: xs
        ) [])
    else
        None

// Input type
type Input =
    | Number of int
    | Skip
    | Quit
    | Invalid

module Input =
    let parse str =
        match str with
        | MatchIX @"\A\s* (\d+) \s*\z" [_;number]  -> Number (int number)
        | MatchIX @"\A\s* (s|sk|ski|skip) \s*\z" m -> Skip
        | MatchIX @"\A\s* (q|qu|qui|quit) \s*\z" m -> Quit
        | _                                        -> Invalid

let hasPrefix str =
    match str with
    | MatchIX @"\A\d+\.\s+" _ -> true
    | _                       -> false

let removePrefix str =
    Regex.Replace(str, @"\A\d+\.\s+", "")

let newFilename number file =
    let file =
        if   hasPrefix file
        then removePrefix file
        else file
    sprintf "%02d. %s" number file

let fmt fmt args =
    AnsiConsole.MarkupLine(fmt, args)

// Main Program Loop
let rec ask files =
    match files with
    | []          -> ()
    | file::files ->
        if File.Exists file then
            // Show User the file to change
            fmt "File: [blue]{0}[/]" [|file|]

            // Warn user if file has prefix
            if hasPrefix file then
                fmt "[red]Warning:[/] Prefix already available. Enter Number to overwrite or skip" [||]

            // Ask User for input
            let input = Input.parse (AnsiConsole.Ask("Prefix: "))
            match input with
            | Number prefix ->
                let newFile = newFilename prefix file

                if File.Exists newFile then
                    printfn "Error: No renaming; File already exists: %s\n" newFile
                else
                    try
                        File.Move(file, newFile)
                        fmt "Renamed: [blue]{0}[/] -> [aqua]{1}[/]\n" [|file; newFile|]
                    with
                    | exn ->
                        printfn "Error: %O\n" exn
                ask files
            | Skip ->
                fmt "Skipped: [blue]{0}[/]\n" [|file|]
                ask files
            | Quit ->
                System.Environment.Exit 0
            | Invalid ->
                fmt "[red]Error:[/] Input invalid: Provide [[number]] s(kip) or q(uit)\n" [||]
                ask (file::files)

// Get Command-Line Arguments of script execution
let files = Array.toList (Array.skip 2 (System.Environment.GetCommandLineArgs()))

// Program info
fmt "Call: prefix [red]*.mp3[/]" [||]
fmt "This tool prefixes all filenames provided as arguments" [||]
fmt "If Prefix is a number like [red]5[/] it wil rename a file to: [red]05. filename.mp3[/]" [||]
fmt "Valid inputs: [[Integer]] s(kip) r(emove) q(uit)\n" [||]

ask files
