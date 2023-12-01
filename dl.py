'''
Python file to pull and download all microbiome data from
https://ai-for-life-sciences-1.s3.amazonaws.com/
https://ai-for-life-sciences-2.s3.amazonaws.com/
Yet to come: unpacking gzip file to csv file

'''


import requests
import xmltodict
import json
import gzip
import csv
import os

def pullData(data_url):
    if data_url == None:
        data_url = "https://ai-for-life-sciences-1.s3.amazonaws.com/"

    data = requests.get(data_url)
    data_dict = xmltodict.parse(data.text)

    contents = data_dict["ListBucketResult"]["Contents"]
    print(f"Downloading {len(contents)} items from {data_url}")
    for item in contents:
        key = item["Key"]   
        try: 
            prefix = key.split('/')[0]
            filename = key.split('/')[1]
        except IndexError:
            prefix = "metadata"
            filename = key

        # create folder
        if not os.path.exists(prefix):
            os.mkdir(prefix)
        
        if os.path.exists(f"{prefix}/{filename}"):
            continue
        print(f"Getting file from {key}... Last file is {contents[-1]['Key']}")
        temp_url = data_url + key
        fq_gz = requests.get(temp_url, allow_redirects=True)

        #  Resume from SRR25384272
        if not os.path.exists(f"{prefix}/{filename}"):
            print(f"Saving file to {prefix}_{filename}")
            save_file = open(f"{prefix}/{filename}", "wb")
            save_file.write(fq_gz.content)
            save_file.close()
        
        '''
        filename_csv = filename.replace(".gz", ".csv")
        print(filename_csv)
        if not os.path.exists(filename_csv):
            f = gzip.open(f"{prefix}/{filename}", mode='rt', newline=":")
            csvobj = csv.reader(f, delimiter = ':', quotechar="'")

        '''

pullData("https://ai-for-life-sciences-1.s3.amazonaws.com/")
pullData("https://ai-for-life-sciences-1.s3.amazonaws.com/?list-type=2&start-after=SRR25384726/Lucas0441.2.fq.gz")
pullData("https://ai-for-life-sciences-2.s3.amazonaws.com/?list-type=2&start-after=SRR24062152/372_HLTHGDRXX.2.fq.gz")
pullData("https://ai-for-life-sciences-2.s3.amazonaws.com/?list-type=2&start-after=SRR24067941/793_HJVJHDRXX.2.fq.gz")
pullData("https://ai-for-life-sciences-2.s3.amazonaws.com/?list-type=2&start-after=SRR24068441/813_HJVJHDRXX.2.fq.gz")
pullData("https://ai-for-life-sciences-2.s3.amazonaws.com/?list-type=2&start-after=SRR24069575/ITS__574.fq.gz")


