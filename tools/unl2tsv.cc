#include <fstream>
#include <iostream>
#include <sstream>
#include <string>

using namespace std;

namespace {
    void translate (string& line, ofstream& os)
    {
        stringstream is(line);
        string token;
        bool first = true;
        while (getline(is, token, '|')) {
            if (first) { first = false; }
            else       { os << "\t";  }
            os << (token == "" ? "\\N" : token);
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
