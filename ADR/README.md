# Lendscape Architecture Decision Records

This README file documents the process of how to update the current CSV file to add a new architecture decision record and reflect as container into Lucidchart.

## What is an architecture decision record?

Below are excerpts from [Joel Parker Henderson's](https://github.com/joelparkerhenderson) repository: [architecture-decision-record](https://github.com/joelparkerhenderson/architecture-decision-record/):

An **architecture decision record** (ADR) is a document that captures an important architectural decision made along with its context and consequences.

An **architecture decision** (AD) is a software design choice that addresses a significant requirement.

An **architecture decision log** (ADL) is the collection of all ADRs created and maintained for a particular project (or organization).

An **architecturally-significant requirement** (ASR) is a requirement that has a measurable effect on a software system’s architecture.

All these are within the topic of **architecture knowledge management** (AKM).

## Editing the CSV File

The file included in this repo is a simple CSV file with the following headers:
* ID
* Category
* Title
* Status
* Initiator
* Context
* Decision
* Positive Consequences
* Negative Consequences

Each column tries to add detail to make a cohesive information about the architecture decision.

1. Clone this repository locally
2. Open the CSV file using your preferred tool
3. Add architecture decision records without conflicting with existing ID number

It's that simple.

## Auditing changes to the CSV file

The CSV file is committed into version control for better auditing of the changes that has happened on the file. It will be an agreed upon practice that changes will be pushed into version control with proper commit message detailing the changes on the ADR CSV applied.

## Visualizing the ADR CSV in Lucidchart

It is possible to use this version controlled CSV file as data source for Smart Containers in Lucidchart. This will provide a way to visualize the decision records and make it presentable for client sharing.

To do this:

### Creating a new Smart Containers diagram with imported data

1. Create or open your diagram. 
2.  Create a new page if your ADR page isn't existing yet.
3. Click "File" on the top-left > Import Data > and choose Smart Containers from the left pane:
   
![image](https://github.com/CloudBridgeTechnologies/sow894-lendscape-mobilize/assets/3380853/8be207d7-e8be-4409-be3e-993075365cbe)

4. Click "Import Your Data" > Choose CSV > then Next:
   
![image](https://github.com/CloudBridgeTechnologies/sow894-lendscape-mobilize/assets/3380853/b0345406-7f4d-49c7-a9be-85828f2db7ae)

5. Choose the CSV file from this repository by navigating to your local machine copy of the repo
6. Configure your Smart Containers to specify the fields to use:
   
![image](https://github.com/CloudBridgeTechnologies/sow894-lendscape-mobilize/assets/3380853/63d1cc8e-d72b-4bc3-8d08-2f5d5a538fb1)

7. Further configure your Smart Containers by double-clicking the containers and use the Smart Containers pane in right to Manage Fields, order it, group, etc. :
   
![image](https://github.com/CloudBridgeTechnologies/sow894-lendscape-mobilize/assets/3380853/92213e4d-9777-4d03-b5ed-236bc7461ba1)

The result of this is an automatically grouped Smart Containers that show you ADRs!

![image](https://github.com/CloudBridgeTechnologies/sow894-lendscape-mobilize/assets/3380853/8411757d-9170-4c58-8faf-6efd30f1def6)


### Replacing or Updating Content for your ADR Diagram
To update the data once you updated the CSV file, 
1. Double-Click the Smart Container and the Smart Containers config pane will be shown
2. Click "Data" Tab > Collapse "Manage Data" > click Replace Dataset:
   
![image](https://github.com/CloudBridgeTechnologies/sow894-lendscape-mobilize/assets/3380853/e3ccb205-2578-4517-a702-1551b0116aa2)

3. Choose the updated CSV data that you have modified and commited to version control
