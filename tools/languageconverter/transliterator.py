letters = ['A','B','C','D','E','F','G','H','I',\
           'J','K','L','M','N','O','P','Q','R',\
           'S','T','U','V','W','X','Y','Z','a','b','c','.',' ']
phonetics = ['m','b','f','θ','ð','t','d','s','z',\
           'ɾ','r','l','ʃ','dʒ','j','g','x','ɣ',\
           'ħ','ʕ','h','ʔ','i','ɛ','a','u','o','ɔ','ə','.',' ']

pholet = {}
for i in range(len(letters)):
    pholet[phonetics[i]] = letters[i]

def convert(mes):
    result = ""
    counter = 0
    for char in mes:
        if(char == 'd' and mes[counter + 1] == 'ʒ'):
            result += 'N'
        else:
            result += pholet[char] if char in pholet else ''
        counter += 1
    print(result)
    print("<font face='Shage'>" + result + "</font>")


def main():
    while(True):
        convert(input("Enter IPA to convert"))

main()
