package jta.util.macro;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Type;

/**
 * Fixes C++ name clashes with Objective-C on iOS (and macOS).
 *
 * On Apple platforms hxcpp compiles some files as Objective-C++ (e.g. `__boot__.mm`),
 * which pulls in `<objc/objc.h>`. That header defines `Nil` and `nil` as macros
 * (both `nullptr`), so any Haxe type or value named `Nil`/`nil` breaks the build:
 *
 *     include/thx/Nil.h: error: expected unqualified-id
 *         HX_DECLARE_CLASS1(thx,Nil)
 *
 * `thx.core` (a Polymod dependency) has exactly that: `enum Nil { nil; }`.
 * This macro renames them on the C++ side only, via `@:native`. Haxe code
 * (and scripts) still use `thx.Nil` / `nil` as normal.
 *
 * Enabled from Project.xml:
 *     --macro addGlobalMetadata('thx.Nil', '@:build(jta.util.macro.ObjCNameFix.build())')
 */
class ObjCNameFix
{
	/**
	 * Names that Objective-C headers define as macros.
	 */
	static final OBJC_MACROS:Array<String> = ['Nil', 'nil', 'YES', 'NO'];

	public static macro function build():Array<Field>
	{
		final fields:Array<Field> = Context.getBuildFields();
		final localType:Null<Type> = Context.getLocalType();

		// Rename the type itself, e.g. thx.Nil -> thx.ObjCSafe_Nil
		switch (localType)
		{
			case TEnum(ref, _):
				renameType(ref.get().pack, ref.get().name, ref.get().meta, ref.get().pos);
			case TInst(ref, _):
				renameType(ref.get().pack, ref.get().name, ref.get().meta, ref.get().pos);
			default:
		}

		// Rename clashing enum constructors / fields, e.g. nil -> objcsafe_nil
		for (field in fields)
		{
			if (OBJC_MACROS.contains(field.name) && !hasMeta(field.meta, ':native'))
			{
				if (field.meta == null)
					field.meta = [];

				field.meta.push({name: ':native', params: [macro $v{'objcsafe_' + field.name}], pos: field.pos});
			}
		}

		return fields;
	}

	static function renameType(pack:Array<String>, name:String, meta:MetaAccess, pos:Position):Void
	{
		if (!OBJC_MACROS.contains(name) || meta.has(':native'))
			return;

		final nativeName:String = pack.concat(['ObjCSafe_' + name]).join('.');
		meta.add(':native', [macro $v{nativeName}], pos);
	}

	static function hasMeta(meta:Null<Metadata>, name:String):Bool
	{
		if (meta == null)
			return false;

		for (entry in meta)
			if (entry.name == name)
				return true;

		return false;
	}
}
#end
