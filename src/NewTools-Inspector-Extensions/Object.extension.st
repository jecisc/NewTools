Extension { #name : #Object }

{ #category : #'*NewTools-Inspector-Extensions' }
Object >> allInspectorNodes [
	"Answer a list of attributes as nodes"
	
	^ { StInspectorSelfNode hostObject: self }, 
		self inspectorNodes
]

{ #category : #'*NewTools-Inspector-Extensions' }
Object >> breakpointInspection [
	<inspectorPresentationOrder: 998>

	^ StBreakpointInspection on: self
]

{ #category : #'*NewTools-Inspector-Extensions' }
Object >> inspections [
	"This is a utility method that collects all presentations for the current object.
	By default, it simply looks for the #gtInspectorPresentationOrder: pragma.
	The inspector can decice whether or not a presentation should be dispayed.
	Subclasses might want to override it for more special behavior."
	| pragmas |
	
	pragmas := Pragma
		allNamed:  StInspector extensionsPragma
		from: self class
		to: ProtoObject
		sortedUsing: [ :x :y | (x argumentAt: 1) < (y argumentAt: 1) ].

	"pragmas := pragmas select: [ :aPragma | aGTInspector shouldDisplayPresentationCreatedBy: aPragma method ]."
	
	^ (pragmas 
		sorted: [ :a :b | (a argumentAt: 1) < (b argumentAt: 1) ])
		collect: [ :eachPragma | 
			self perform: eachPragma methodSelector  ]
]

{ #category : #'*NewTools-Inspector-Extensions' }
Object >> inspectorNodes [
	"Answer a list of attributes as nodes"
	
	^ (StNodeCollector for: self) collectNodes
	  
]

{ #category : #'*NewTools-Inspector-Extensions' }
Object >> metaInspection [
	<inspectorPresentationOrder: 999>

	^ StMetaBrowser on: self
]

{ #category : #'*NewTools-Inspector-Extensions' }
Object >> rawInspection [
	"This is the most basic presentation showing the state of the object"

	^ StRawInspection on: self
]

{ #category : #'*NewTools-Inspector-Extensions' }
Object >> stInspect [
	"Temporary to experiment, should be replaced by inspect later"

	^ StInspector inspect: self
]
