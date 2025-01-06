# AWS IAM (Identity & Access Management) Credential Reporting Script

<br>

**BLUF:** This repo contains a script used to pull IAM user metrics from an AWS account and output it as a ```.csv``` file. The script first performs an _IAM Credential Report_ for username, password, and access key data (PW/key age, console/programmatic access, service last used, etc.), then pulls in group policy and attached user policy information per user. The user data is organized and cleaned using Bash and Python commands, respectively.

<br>

You can modify this for your account/organization needs, as well as add the ```--profile``` option if the AWS account in question is segmented as such.

<br>

**NOTE:** My Python is quite basic. Obviously, feel free to modify this script to suit your own data cleansing workflow. The most important parts are the AWS commands; y'all can do what you want from there!

<br>

**NOTE II:** Speaking of Python, take some time to read through the data cleansing section, particularly _line 38_. Some of the columns I dropped may be useful for your needs; just delete them from the purge, if that is the case.

<br>

In previous roles I've worked, I always pushed this to an S3 bucket for centralized access and back-up purposes. This part of the script (at the bottom) is commented out. Modify that part per your S3 bucket name or get rid of it if you have a different workflow.

<br>

I've included a sample output report using dummy IAM users in my personal AWS account for y'all to see the final product. I HIGHLY recommend opening this in Excel (or Google Sheets) for formatting and presentation (obvi, be sure to save as a ```.xlsx``` file).

<br>

# Requirements

* **AWS CLI** (refer to [this link](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) for install instructions)
   * If you aren't familiar with the ```aws configure``` process, refer to [the following](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

* **Miniconda (3.x)** or Python3 (install script is included in this repo; it should install the latest ver. of Miniconda3 based on your OS)

* Some kind of **Linux distro** (ideally, a RH-based distro or Amazon Linux); WSL works...

<br>

# Instructions

1. Install Miniconda by running the install script. If Miniconda (or Python) is already installed, be sure to modify **line 31** of ```credential-report.sh``` to point to your installation:

```bash
./install-miniconda3.sh
```
   * (**NOTE:** If you have trouble with the install script due to your machine type (i.e., janky OS install on a Raspberry Pi, etc.), I recommend consulting the [official documentation](https://repo.anaconda.com/miniconda/).

2. (Optional, but recommended) Create a virtual conda environment to avoid potential conflicts with other Python packages you may work with in the future:
```bash
conda create -n iam_report python=3.12
conda activate iam_report
```

3. Install **Pandas** and **Numpy** Python libraries (if not already present), which the script requires for data cleansing:

```bash
pip install pandas numpy
```

4. Run the ```credential-report.sh``` script:

```bash
./credential-report.sh
```

5. Wait 120 seconds (update part of line 7 to read ```300s``` or larger depending on the size of your organization / AWS account; **Wait time is used for the _IAM Credential Report_ to complete before the rest of the script runs**), then wait for the rest of the script to complete (the script will tell you which step is processing via ```echo``` commands).
