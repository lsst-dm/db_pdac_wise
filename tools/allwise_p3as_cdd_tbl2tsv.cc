#include <algorithm>
#include <fstream>
#include <iostream>
#include <iterator>
#include <sstream>
#include <string>
#include <vector>

using namespace std;

namespace {
    void translate (string& line, ofstream& os)
    {
        stringstream ss(line);
        istream_iterator<string> begin(ss);
        istream_iterator<string> end;

        string token = "";
        int idx = 0;
        for (istream_iterator<string> itr=begin; itr !=end ; ++itr, ++idx ) {

            switch (idx) {

                // Column numbers where space separated 'DATA TIME' items begin

                case   1:
                case  23:
                case 142:
                case 144:
                case 146:
                case 148:

                    // Store the DATE substring for further concatenation with
                    // the subsequent TIME

                    token = *itr + " ";
                    break;

                default:

                    // Allways concatenate with the previously found substring
                    // even if none was there. Reset the stored substring after
                    // dumpting result.

                    token += *itr;
                    if (idx) { os << "\t"; }
                    os << (token == "null" ? "\\N" : token);
                    token = "";
            }
        }
        os << "\n";
    }
}

int main (int argc, char* argv[])
{

    if (argc != 3) {
        cerr << "Usage: <infile> <outfile>" << endl;
        return 1;
    }
    const string  infile_name = argv[1],
                 outfile_name = argv[2];

    ifstream infile {infile_name,  ifstream::in};
    ofstream outfile{outfile_name, ofstream::out};


    for (string line; getline(infile, line);) {
        ::translate(line, outfile);
    }
    return 0;
}
