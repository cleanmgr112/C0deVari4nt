
from zipfile import ZipFile
import shutil
import os
import sys

dirname = os.path.dirname(__file__)

class Misc():
    def unzip_database_file(self, zip_path: str):
        extract_filepath = ""
        with ZipFile(zip_path,'r') as zfiles:
            flist = zfiles.namelist()
            extract_filepath = "databases/" + flist[0].replace("/.dbinfo", "") + "/"

            zfiles.extractall("databases")
        
        ## the src files are in /opt/src
        shutil.unpack_archive(extract_filepath + "src.zip", extract_filepath)

        return extract_filepath


if __name__ == "__main__":

    # extract file from first arg of code (must be zip file)
    file = sys.argv[-1]

    misc = Misc()
    db_path = misc.unzip_database_file(file)
    print(db_path)