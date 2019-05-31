#! /usr/bin/env perl6
use v6.c;

# A migrations tool for moving old projects which use the old Result API to the new API.
# This tool is by no means perfect and definitly cannot migrate old result code useing with statements (In the new API you need to call .err-to-undef to make a Result::Any with block compatible).
#
# Do not use this tool if you haven't got a backup of your project! This migration tool comes with no garantees.
# I recommmend running the migration tool in explain mode first so that you may check the changes which are being planned.
# After checking the planned changes, pass the --apply-migration flag to modify your project.
#
# If you need more information on what files the migration is skipping turn on the --verbose flag.

unit sub MAIN(Str $source = './', Bool :$apply-migration, Bool :$verbose);
say 'Migration script is currently in preview mode, pass the "--apply-migration" flag to apply the changes shown below.' unless $apply-migration;

# Checks a line and returns the recommended alteration
sub line-parser(Str $line --> Str) {
    my $migrated = $line;
    my $changed = True;
    loop {
        given $migrated {
            when !$_.defined { last } # End if the line has been emptied
            when /^ '#' / { last } # Skip comments
            when /(.+) 'Result::OK' (.+)/ {
                $migrated = join '', $0, 'Result::Ok', $1;
            }
            when /(.+ ['-->' || 'returns'] \s+) 'Result' <!before ':'> (.+)/ {
                $migrated = join '', $0, 'Result::Any', $1;
            }
            when /(.+) <|w> 'OK' <!before [\' || \"]> ([\s*'(' || \s ] .+)/ {
                $migrated = join '', $0, 'Ok', $1;
            }
            when /(.+) <|w> 'Error' <!before [\' || \"]> ([\s*'(' || \s ] .+)/ {
                $migrated = join '', $0, 'Err', $1;
            }
            when /^\s* 'use' \s+ 'Result::Imports' \s* ';' \s* $/ {
                $migrated = Str; # Empty to remove the line from the file
            }
            default { last } # No change was made this past so end
        }
    }

    $migrated
}
# " fix syntax highlighting...

# Explains what changes will be made in a migration
sub explain-migration(IO::Path $src) {
    say '----> ', $src.Str;
    for $src.lines.kv -> $ln, $line {
        my $changes = (.defined ?? $_ !! '<DELETE>')  given line-parser($line);
        say sprintf("ln %-5s:", $ln), $line, ' => ', $changes if $line ne $changes;
    }
}

# Apply changes to enact a migration
sub apply-migration(IO::Path $src) {
    say '----> ', $src.Str;
    my $changed = False;
    my @lines;
    for $src.lines.kv -> $ln, $line {
        @lines.push: line-parser($line);
        my $changes = (.defined ?? $_ !! '<DELETE>')  given @lines.tail;

        if $line ne $changes {
            say sprintf("ln %-5s:", $ln), $line, ' => ', $changes;
            $changed = True;
        }
    }

    $src.spurt: @lines.grep( *.defined ).join("\n") if $changed;
}

sub collect-soruces(Seq $paths, &migrate) {
    for $paths.values {
        when .basename ~~ /^'.'/ {
            say "Ignored hidden file: '$_'" if $verbose;
        }
        when .f {
            if .extension ~~ <p6 pl6 pl t6 t pm6 pm>.any {
                migrate $_
            }
            else {
                say "Ignored non-perl source: '$_'"  if $verbose;
            }
        }
        when .d {
            say "descending into '$_'"  if $verbose;
            collect-soruces(.dir, &migrate)
        }
        default { warn "Skipped '$_'"  if $verbose }
    }
}

#
# Go
#

say "Searching '$source'";
my $path-seq  = .d ?? .dir !! Seq($_) given $source.IO;
my &migrator = $apply-migration ?? &apply-migration !! &explain-migration;

collect-soruces $path-seq, &migrator;