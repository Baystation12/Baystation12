using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace offsetfixer
{
    class Program
    {
        static void Main(string[] args)
        {
            string pattern = @"(?>pixel_.\s=\s)(.\d*)";
            foreach (var file in Directory.GetFiles(@"G:\Development\Baystation12-Head\maps\exodus","*.dmm")) {
                string input = File.ReadAllText(file);
                var index = 0;
                foreach (Match m in Regex.Matches(input, pattern))
                {
                    Console.WriteLine("'{0}' found at index {1}.", m.Groups[1], m.Index);
                    var d = int.Parse(m.Groups[1].Value);
                    d *= 2;
                    input = input.Remove(m.Groups[1].Index + index, m.Groups[1].Length);
                    input = input.Insert(m.Groups[1].Index + index, d.ToString());
                    index += d.ToString().Length - m.Groups[1].Length;
                }
                File.WriteAllText(file,input);
            }
        }
    }
}
