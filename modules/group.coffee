module.exports =
	admin:
		user:
			add: true
			remove: true
			edit: true
			setGroup: true
		article:
			add: true
			remove: true
			edit: true
			comment: true
			approve: true
		topic:
			add: true
			remove: true
			edit: true
			view: true
	supervisor:
		user:
			add: true
			remove: false
			edit: false
		article:
			add: true
			remove: true
			edit: false
			comment: true
			approve: true
		topic:
			add: true
			remove: true
			edit: true
	author:
		user:
			add: false
			remove: false
			edit: false
		article:
			add: true
			remove: false
			edit: false
			comment: true
			approve: false
		topic:
			add: false
			remove: false
			edit: false
