import json
import os
import argparse

def read_config(path):
    config = json.loads(open(path).read())
    return config

def evaluate(config):
    f = open('.tempScript.sh', 'w')
    f.write(config['cmd'] + '\n')
    f.close()

    f = open('./result_times.csv', 'a')
    f.write("run,elapsed_time,kernel_mode,user_mode,memory_max,memory_average,number_results\n")
    for i in range(config['rounds']):
        os.system('/usr/bin/time -f "'+ str(i) + ',%e,%S,%U,%M,%K" -o ./.temp.result_times.csv bash .tempScript.sh')
        data = open('./.temp.result_times.csv').read()
        number_results = os.popen("wc -l " + config['output_path'] + " | awk -F ' ' '{print $1}'").read()
        data = data.replace('\n', '')
        f.write(data + ',' + number_results)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-c', "--config", required=True, help="Path of the configuration file")
    args = parser.parse_args()
    conf = read_config(args.config)
    evaluate(conf)
    print("Evaluation Finished")

if __name__=='__main__':
    main()