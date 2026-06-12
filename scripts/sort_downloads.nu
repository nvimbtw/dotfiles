#!/usr/bin/env nu

# Sort ~/Downloads into ~/Pictures, ~/Music, and ~/Documents/{pdf,docx,pptx,other}

def main [] {
    let downloads = ($env.HOME | path join "Downloads")
    let pictures  = ($env.HOME | path join "Pictures")
    let music     = ($env.HOME | path join "Music")
    let docs      = ($env.HOME | path join "Documents")

    # Ensure destination dirs exist
    for dir in [
        $pictures
        $music
        ($docs | path join "pdf")
        ($docs | path join "word")
        ($docs | path join "excel")
        ($docs | path join "pptx")
        ($docs | path join "other")
    ] {
        mkdir $dir
    }

    let image_exts    = [png jpg jpeg webp gif svg bmp tiff]
    let audio_exts    = [mp3 wav flac ogg aac m4a]
    let pdf_exts      = [pdf]
    let word_exts     = [docx doc odt rtf txt]
    let excel_exts    = [xlsx xls ods csv]
    let pptx_exts     = [pptx ppt odp]
    let ebook_exts    = [epub mobi]

    let files = (ls $downloads | where type == file)

    for f in $files {
        let name = ($f.name | path basename)
        let ext  = ($name | path parse | get extension | str downcase)

        let dest = if $ext in $image_exts {
            $pictures
        } else if $ext in $audio_exts {
            $music
        } else if $ext in $pdf_exts {
            ($docs | path join "pdf")
        } else if $ext in $word_exts {
            ($docs | path join "word")
        } else if $ext in $excel_exts {
            ($docs | path join "excel")
        } else if $ext in $pptx_exts {
            ($docs | path join "pptx")
        } else if $ext in $ebook_exts {
            ($docs | path join "other")
        } else {
            null
        }

        if $dest != null {
            let target = ($dest | path join $name)
            # Avoid clobbering: append timestamp if target exists
            let final_target = if ($target | path exists) {
                let stem      = ($name | path parse | get stem)
                let ext_part  = ($name | path parse | get extension)
                let timestamp = (date now | format date "%Y%m%d_%H%M%S")
                ($dest | path join $"($stem)_($timestamp).($ext_part)")
            } else {
                $target
            }
            mv $f.name $final_target
            print $"  moved  ($name)  →  ($final_target | str replace $env.HOME "~")"
        }
    }

    let moved_count = ($files | where {|f|
        let ext = ($f.name | path basename | path parse | get extension | str downcase)
        $ext in ($image_exts ++ $audio_exts ++ $pdf_exts ++ $word_exts ++ $excel_exts ++ $pptx_exts ++ $ebook_exts)
    } | length)

    if $moved_count > 0 {
        ^notify-send -i folder "Downloads sorted" $"Moved ($moved_count) files to their folders."
    } else {
        ^notify-send -i folder "Downloads sorted" "Everything is already sorted."
    }
}
