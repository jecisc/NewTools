Class {
	#name : #StNodeCollector,
	#superclass : #Object,
	#instVars : [
		'object'
	],
	#category : #'NewTools-Inspector-Model'
}

{ #category : #'instance creation' }
StNodeCollector class >> for: anObject [

	^ self basicNew 
		initializeObject: anObject;
		yourself
]

{ #category : #building }
StNodeCollector >> collectContextNodes [
	| nodes |
	nodes := OrderedCollection new.
	nodes add: (StInspectorThisContextNode hostObject: self object).
	nodes add: (StInspectorStackTopNode hostObject: self object).
	self object tempNames
		withIndexDo: [ :name :index | 
			nodes
				add:
					(StInspectorContextNamedTempNode
						hostObject: self object
						tempName: name
						tempIndex: index) ].
	^ nodes
]

{ #category : #building }
StNodeCollector >> collectNodes [

	^ 
	self indexedNodes,	
	self slotNodes
]

{ #category : #private }
StNodeCollector >> indexedNodes [
	| nodes indexableDisplayLimit top bottom topLimit bottomLimit |
	
	nodes := OrderedCollection new.
	
	indexableDisplayLimit := GTInspector indexableDisplayLimit.        
	top := 1.
	bottom := self object basicSize.
	topLimit    := indexableDisplayLimit min: bottom.
	bottomLimit := indexableDisplayLimit max: (bottom - indexableDisplayLimit).

	top to: topLimit do: [ :index | 
		nodes add: (StInspectorIndexedNode 
			hostObject: self object
			index: index) ].
	
	bottomLimit + 1 to: bottom do: [ :index |
		nodes add: (StInspectorIndexedNode 
			hostObject: self object
			index: index) ].
	
	^ nodes
]

{ #category : #initialization }
StNodeCollector >> initializeObject: anObject [

	self initialize.
	object := anObject
]

{ #category : #accessing }
StNodeCollector >> object [ 
	
	^ object
]

{ #category : #accessing }
StNodeCollector >> objectClass [ 
	
	^ self object class
]

{ #category : #private }
StNodeCollector >> slotNodes [

	^ self objectClass allSlots collect: [ :each | 
			StInspectorSlotNode 
				hostObject: self object 
				slot: each ]
]
