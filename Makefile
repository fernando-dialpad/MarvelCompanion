.PHONY: graph-infrastructure graph-characters graph-app setup
graph-infrastructure:
	swift package show-dependencies --package-path Packages/Infrastructure/DataManager --format dot \
		| perl -pe 's|.*\/(.*?)" \[label=.*?\]|"\1" \[label="\1"\]|g' \
		| perl -pe 's|".*\/(.*?)" -> ".*\/(.*?)"|"\1" -> "\2"|g' > infrastructure-data-manager-graph.dot
	swift package show-dependencies --package-path Packages/Infrastructure/Notifier --format dot \
		| perl -pe 's|.*\/(.*?)" \[label=.*?\]|"\1" \[label="\1"\]|g' \
		| perl -pe 's|".*\/(.*?)" -> ".*\/(.*?)"|"\1" -> "\2"|g' > infrastructure-notifier-graph.dot
	perl scripts/merge-graphviz.pl infrastructure-data-manager-graph.dot infrastructure-notifier-graph.dot \
		| dot -Tsvg -o Dependencies/infrastructure-graph.svg
	rm infrastructure-data-manager-graph.dot infrastructure-notifier-graph.dot
graph-characters:
	swift package show-dependencies --package-path Packages/Features/MarvelCharacter --format dot \
		| perl -pe 's|.*\/(.*?)" \[label=.*?\]|"\1" \[label="\1"\]|g' \
		| perl -pe 's|".*\/(.*?)" -> ".*\/(.*?)"|"\1" -> "\2"|g' \
		| dot -Tsvg -o Dependencies/characters-graph.svg
graph-app:
	swift package show-dependencies --package-path Packages/Features/AppRoot --format dot \
		| perl -pe 's|.*\/(.*?)" \[label=.*?\]|"\1" \[label="\1"\]|g' \
		| perl -pe 's|".*\/(.*?)" -> ".*\/(.*?)"|"\1" -> "\2"|g' \
		| dot -Tsvg -o Dependencies/app-graph.svg

setup:
	brew bundle
