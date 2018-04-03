letters = ['A','B','C','D','E','F','G','H','I',\
           'J','K','L','M','N','O','P','Q','R',\
           'S','T','U','V','W','X','Y','Z','a','b','c','.',' ']
phonetics = ['m','b','f','θ','ð','t','d','s','z',\
           'ɾ','r','l','ʃ','dʒ','j','g','x','ɣ',\
           'ħ','ʕ','h','ʔ','i','ɛ','a','u','o','ɔ','ə','.',' ']

pholet = {}
for i in range(len(letters)):
    pholet[letters[i]] = phonetics[i]

def convert(mes):
    result = ""
    for char in mes:
            result += pholet[char] if char in pholet else ''
    print(result)


def main():
    while(True):
        convert(input("Enter Shage to convert"))

main()
