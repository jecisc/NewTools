Class {
	#name : #StMetaBrowser,
	#superclass : #StInspection,
	#instVars : [
		'classes',
		'methods',
		'source'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #specs }
StMetaBrowser class >> defaultSpec [
	^ SpecLayout composed
		newColumn: [ :mainColumn | 
			mainColumn
				newRow: [ :r | 
					r
						newColumn: #classes;
						newColumn: #methods ];
				newRow: [ :r2 | r2 newColumn: #source ] ];
		yourself
]

{ #category : #initialization }
StMetaBrowser >> initialize [ 

	super initialize.
	self title: 'Meta'
]

{ #category : #initialization }
StMetaBrowser >> initializeWidgets [
	| classHierarchy |
	classes := self newTreeTable.
	methods := self newList.
	source := self newCode.
	source aboutToStyle: true.
	methods
		whenSelectionChangedDo: [ :selection | 
			| method |
			method := selection selectedItem.
			method
				ifNil: [ source text: '' ]
				ifNotNil: [ source behavior: method methodClass.
					source text: method sourceCode ] ].
	methods displayBlock: #selector.
	classes
		whenSelectionChangedDo: [ :selection | 
			| class |
			class := selection selectedItem.
			class
				ifNil: [ methods items: SortedCollection new ]
				ifNotNil: [ | sortedMethods |
					sortedMethods := SortedCollection
						sortBlock: [ :a :b | a selector <= b selector ].
					sortedMethods addAll: class methods.
					methods items: sortedMethods ].
			methods unselectAll ].
	classes
		addColumn:
			(StringTableColumn new
				title: 'Class hierarchy';
				evaluated: #name;
				yourself).
	classHierarchy := self model class withAllSuperclasses reversed.
	classes roots: {classHierarchy first}.
	classes
		children:
			[ :aClass | classHierarchy select: [ :subclass | subclass superclass == aClass ] ].
	classes selectPath: (classHierarchy collect: [ :aClass | 1 ])
]