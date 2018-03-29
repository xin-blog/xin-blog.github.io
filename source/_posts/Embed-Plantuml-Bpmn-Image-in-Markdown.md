---
title: Embed PlantUML & Activiti BPM Image in Markdown
---

## Deploy Image Server

<https://github.com/bryt-li/image-server>

### PlantUML & Graphviz

```
@startuml

class Products #cyan {
	Loan Products
	==
	#id
	--
	+name : varchar(128) -- name of product
	amount : decimal(19,4) NOT NULL -- amount of money
	days : int unsigned -- loan days
	preloanFee : decimal(19,4) NOT NULL -- poundage
	installments : int unsigned NOT NULL -- by stages times
	interestRate : decimal(22,7) NOT NULL -- interest rate
	overdueInterestRate : decimal(22,7) NOT NULL -- overdue interest rate
	minCredit : int unsigned -- min credit lines
}

note as N2
comment
open-market product: <b>minCredit=0</b>
white-list product: <b>minCredit=1</b>
salary-deduction product: <b>minCredit=2</b>
end note
N2 . Products

class Accounts #cyan {
	Investor & Borrower Accounts
	==
	#id
	id_Person : bigint unsigned
	id_Certificate : bigint unsigned
	--
	+name : varchar(128)
	+mobile : varchar(128)
	passWordWrongNumber : int -- times of wrong password
	lockedAt : datetime -- account locked time
	credit : int unsigned -- credit lines
	openId : varchar(128) -- single token oauth returned
	..
	isLocked : boolean
}

note as N1
open-market account: <b>credit=0</b>
white-list account: <b>credit=1</b>
salary-deduction account: <b>credit=2</b>
end note
N1 . Accounts



class Loans #cyan {
	Loans information
	==
	#id
	id_Borrower : bigint unsigned
	id_Investor : bigint unsigned
	id_Product : bigint unsigned
	--
	purpose : varchar(128)
	status : varchar(128)
	instanceId : bigint unsigned
	term : varchar(128)
	loanToken : varchar(128)
	..
	principal : decimal(20,6) default 0
	fee : decimal(20,6) default 0
	interest : decimal(20,6) default 0
	overdueInterest : decimal(20,6) default 0
	amount : decimal(16,2) default 0
	..
	repaidPrincipal : decimal(20,6) default 0
	repaidFee : decimal(20,6) default 0
	repaidInterest : decimal(20,6) default 0
	repaidOverdueInterest : decimal(20,6) default 0
}

Loans --> Products
Loans --> Accounts
@enduml
```

### Activiti BPM Image
```
<?xml version="1.0" encoding="UTF-8"?>
<definitions xmlns="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:activiti="http://activiti.org/bpmn" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:omgdc="http://www.omg.org/spec/DD/20100524/DC" xmlns:omgdi="http://www.omg.org/spec/DD/20100524/DI" typeLanguage="http://www.w3.org/2001/XMLSchema" expressionLanguage="http://www.w3.org/1999/XPath" targetNamespace="http://www.activiti.org/test">
  <process id="FooProcess" name="Foo Process" isExecutable="true">
    <startEvent id="startevent1" name="Start"></startEvent>
    <userTask id="usertask1" name="User Task"></userTask>
    <sequenceFlow id="flow1" name="test" sourceRef="startevent1" targetRef="usertask1"></sequenceFlow>
    <endEvent id="endevent1" name="End"></endEvent>
    <sequenceFlow id="flow2" name="exit" sourceRef="usertask1" targetRef="endevent1"></sequenceFlow>
  </process>
  <bpmndi:BPMNDiagram id="BPMNDiagram_FooProcess">
    <bpmndi:BPMNPlane bpmnElement="FooProcess" id="BPMNPlane_FooProcess">
      <bpmndi:BPMNShape bpmnElement="startevent1" id="BPMNShape_startevent1">
        <omgdc:Bounds height="35.0" width="35.0" x="30.0" y="40.0"></omgdc:Bounds>
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape bpmnElement="usertask1" id="BPMNShape_usertask1">
        <omgdc:Bounds height="55.0" width="105.0" x="110.0" y="30.0"></omgdc:Bounds>
      </bpmndi:BPMNShape>
      <bpmndi:BPMNShape bpmnElement="endevent1" id="BPMNShape_endevent1">
        <omgdc:Bounds height="35.0" width="35.0" x="260.0" y="40.0"></omgdc:Bounds>
      </bpmndi:BPMNShape>
      <bpmndi:BPMNEdge bpmnElement="flow1" id="BPMNEdge_flow1">
        <omgdi:waypoint x="65.0" y="57.0"></omgdi:waypoint>
        <omgdi:waypoint x="110.0" y="57.0"></omgdi:waypoint>
        <bpmndi:BPMNLabel>
          <omgdc:Bounds height="13.0" width="100.0" x="65.0" y="57.0"></omgdc:Bounds>
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNEdge>
      <bpmndi:BPMNEdge bpmnElement="flow2" id="BPMNEdge_flow2">
        <omgdi:waypoint x="215.0" y="57.0"></omgdi:waypoint>
        <omgdi:waypoint x="260.0" y="57.0"></omgdi:waypoint>
        <bpmndi:BPMNLabel>
          <omgdc:Bounds height="13.0" width="100.0" x="215.0" y="57.0"></omgdc:Bounds>
        </bpmndi:BPMNLabel>
      </bpmndi:BPMNEdge>
    </bpmndi:BPMNPlane>
  </bpmndi:BPMNDiagram>
</definitions>
```
