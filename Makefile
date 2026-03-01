b:
	dart run build_runner build --delete-conflicting-outputs

f:
	dart fix --apply

ab:
    flutter build appbundle

apkd:
    flutter build apk --debug

apk:
    flutter build apk