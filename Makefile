.PHONY: graph graph-infrastructure graph-characters graph-events graph-favorites graph-alert graph-app graph-features setup
graph-infrastructure:
	swift package show-dependencies --package-path Packages/Infrastructure/DataManager --format dot \
		| perl -pe 's|.*\/(.*?)" \[label=.*?\]|"\1" \[label="\1"\]|g' \
		| perl -pe 's|".*\/(.*?)" -> ".*\/(.*?)"|"\1" -> "\2"|g' \
		| dot -Tsvg -o Dependencies/infrastructure-graph.svg
graph-characters:
	swift package show-dependencies --package-path Packages/Features/MarvelCharacter --format dot \
		| perl -pe 's|.*\/(.*?)" \[label=.*?\]|"\1" \[label="\1"\]|g' \
		| perl -pe 's|".*\/(.*?)" -> ".*\/(.*?)"|"\1" -> "\2"|g' \
		| dot -Tsvg -o Dependencies/characters-graph.svg
graph-events:
	swift package show-dependencies --package-path Packages/Features/MarvelEvent --format dot \
		| perl -pe 's|.*\/(.*?)" \[label=.*?\]|"\1" \[label="\1"\]|g' \
		| perl -pe 's|".*\/(.*?)" -> ".*\/(.*?)"|"\1" -> "\2"|g' \
		| dot -Tsvg -o Dependencies/events-graph.svg
graph-favorites:
	swift package show-dependencies --package-path Packages/Features/MarvelFavorite --format dot \
		| perl -pe 's|.*\/(.*?)" \[label=.*?\]|"\1" \[label="\1"\]|g' \
		| perl -pe 's|".*\/(.*?)" -> ".*\/(.*?)"|"\1" -> "\2"|g' \
		| dot -Tsvg -o Dependencies/favorites-graph.svg
graph-alert:
	swift package show-dependencies --package-path Packages/Features/MarvelAlert --format dot \
		| perl -pe 's|.*\/(.*?)" \[label=.*?\]|"\1" \[label="\1"\]|g' \
		| perl -pe 's|".*\/(.*?)" -> ".*\/(.*?)"|"\1" -> "\2"|g' \
		| dot -Tsvg -o Dependencies/alert-graph.svg
graph-app:
	swift package show-dependencies --package-path Packages/Features/MarvelRoot --format dot \
		| perl -pe 's|.*\/(.*?)" \[label=.*?\]|"\1" \[label="\1"\]|g' \
		| perl -pe 's|".*\/(.*?)" -> ".*\/(.*?)"|"\1" -> "\2"|g' \
		| dot -Tsvg -o Dependencies/app-graph.svg
graph-features:
	swift package show-dependencies --package-path Packages/Features/MarvelRoot --format dot \
		| perl -pe 's|.*\/(.*?)" \[label=.*?\]|"\1" \[label="\1"\]|g' \
		| perl -pe 's|".*\/(.*?)" -> ".*\/(.*?)"|"\1" -> "\2"|g' \
		| grep -E 'digraph DependenciesGraph {|node \[shape = box\]|}|Marvel' \
		| grep -v 'DataManager' \
		| grep -v 'Notifier' \
		| grep -v 'CoreUI' \
		| dot -Tsvg -o Dependencies/features-graph.svg
graph: graph-infrastructure graph-characters graph-events graph-favorites graph-alert graph-features graph-app

setup:
	brew bundle
