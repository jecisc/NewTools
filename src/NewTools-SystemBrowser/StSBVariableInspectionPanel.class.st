Class {
	#name : #StSBVariableInspectionPanel,
	#superclass : #StSBPanel,
	#instVars : [
		'methodList',
		'variableList'
	],
	#category : #'NewTools-SystemBrowser-View'
}

{ #category : #specs }
StSBVariableInspectionPanel class >> defaultSpec [

	^ SpecPanedLayout newHorizontal
		add: #variableList;
		add: #methodList;
		yourself
]

{ #category : #initialization }
StSBVariableInspectionPanel >> defineInputPorts [

	^ { 
	SpecListItemsPort newDelegate: [ self variableList ].
	SpecListItemsPort newName: 'method-items' delegate: [ self methodList ] 
	}	
]

{ #category : #initialization }
StSBVariableInspectionPanel >> defineOutputPorts [

	^ { 
	SpecListSelectionPort newDelegate: [ self methodList ].
	SpecListSelectionPort newName: #'variable-selection' delegate: [ self variableList ]
	}
]

{ #category : #initialization }
StSBVariableInspectionPanel >> initializeWidgets [
	
	variableList := self newTable 
		hideColumnHeaders;
		addColumn: (StringTableColumn evaluated: #name);
		yourself.
	methodList := self newTable
		hideColumnHeaders;
		addColumn: (StringTableColumn evaluated: #name);
		yourself.
		
	variableList transmitTo: methodList transform: #methods.
	"clean methods when changing variables"
	variableList whenModelChangedDo: [ methodList items: #() ].	
]

{ #category : #accessing }
StSBVariableInspectionPanel >> methodList [
	^ methodList
]

{ #category : #accessing }
StSBVariableInspectionPanel >> variableList [
	^ variableList
]
