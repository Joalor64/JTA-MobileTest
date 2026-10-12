package jta.util.macro;

#if macro
import haxe.io.Path;
import haxe.macro.Context;
import haxe.macro.Expr;
import sys.FileSystem;

/**
 * Helpers for hxcpp `@:buildXml` includes.
 */
class BuildXmlMacro
{
	/**
	 * Adds `@:buildXml('<include name="..."/>')` pointing at a file next to the
	 * class's own source file, using an **absolute** path.
	 *
	 * A relative path like `../../../../source/...` only works when hxcpp builds
	 * from a folder exactly four levels below the project (e.g. `export/release/windows/obj`).
	 * iOS (and some other targets) build from a different depth, which causes
	 * "Could not find include file". An absolute path works everywhere.
	 *
	 * Usage: `@:build(jta.util.macro.BuildXmlMacro.includeLocal('build.xml'))`
	 */
	public static macro function includeLocal(file:String = 'build.xml'):Array<Field>
	{
		final cls = Context.getLocalClass().get();
		final sourceFile:String = Context.getPosInfos(cls.pos).file;
		final dir:String = Path.directory(FileSystem.fullPath(sourceFile));
		final path:String = Path.normalize(Path.join([dir, file]));

		if (!FileSystem.exists(path))
			Context.error('BuildXmlMacro: could not find "$path"', cls.pos);

		final xml:String = '<include name="$path" />';
		cls.meta.add(':buildXml', [macro $v{xml}], cls.pos);

		return null;
	}
}
#end
