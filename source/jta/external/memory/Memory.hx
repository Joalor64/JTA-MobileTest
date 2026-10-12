package jta.external.memory;

#if cpp
import cpp.SizeT;

/**
 * Memory class to properly get accurate memory counts
 * for the program.
 * @author Leather128 (Haxe) - David Robert Nadeau (Original C Header)
 */
@:buildXml('
	<files id='haxe'>
        <compilervalue name="-I" value="${PROJECT_DIR}/include/" />
    </files>

    <files id='__main__'>
        <compilervalue name="-I" value="${PROJECT_DIR}/include/" />
    </files>
	
	<files id="memory">
		<compilervalue name="-I" value="${PROJECT_DIR}/include/" />
		<file name="${PROJECT_DIR}/src/memory.cpp" />
	</files>
	
	<target id="haxe">
		<files id="memory" />
	</target>
')
@:include("memory.hpp") extern class Memory
{
	/**
	 * Returns the peak (maximum so far) resident set size (physical
	 * memory use) measured in bytes, or zero if the value cannot be
	 * determined on this OS.
	 */
	@:native("getPeakRSS")
	public static function getPeakUsage():SizeT;

	/**
	 * Returns the current resident set size (physical memory use) measured
	 * in bytes, or zero if the value cannot be determined on this OS.
	 */
	@:native("getCurrentRSS")
	public static function getCurrentUsage():SizeT;
}
#else

/**
 * If you are not running on a CPP Platform, the code just will not work properly, sorry!
 * @author Leather128
 */
class Memory
{
	/**
	 * (Non cpp platform)
	 * Returns 0.
	 */
	public static inline function getPeakUsage():UInt
		return 0;

	/**
	 * (Non cpp platform)
	 * Returns 0.
	 */
	public static inline function getCurrentUsage():UInt
		return 0;
}
#end
