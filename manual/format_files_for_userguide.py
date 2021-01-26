#!/usr/bin/env python3

import os

def create_texlist(path_to_reader: str,
                   path_to_writer: str,
                   list_type: str) -> None:
    readerpath = path_to_reader
    writerpath = path_to_writer
    try:
        f = open(readerpath,'r')
    except OSError:
        raise RuntimeError(f'Failed to open file {readerpath}.')
    else:
        f.close()

    # remove old file
    if os.path.exists(writerpath):
        os.remove(writerpath)
    with open(readerpath,'r') as reader, open(writerpath,'w') as writer:
        writer.write('\\begin{'+f'{list_type}'+'}\n')
        wholefile = reader.read()
        # clean out latex commands
        wholefile = wholefile.replace(' \\',' {\\textbackslash}')
        sentences = wholefile.split('- ')
        for sentence in sentences:
            if sentence != '':
                # writer.write('\n')
                writer.write(f'    \item {sentence}')

        writer.write('\end{'+f'{list_type}'+'}')

def main():
    kb_path = '../KNOWN_BUGS'
    kb_tex_path = 'known_bugs.tex'

    create_texlist(path_to_reader=kb_path,
                   path_to_writer=kb_tex_path,
                   list_type='enumerate')

if __name__== "__main__":
   main()
