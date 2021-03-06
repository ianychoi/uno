using Uno.Compiler.ExportTargetInterop;

namespace Uno
{
    [extern(DOTNET) DotNetType("System.IntPtr")]
    [extern(CPLUSPLUS) Set("TypeName", "void*")]
    [extern(CPLUSPLUS) Set("DefaultValue", "NULL")]
    [extern(JAVASCRIPT) Set("DefaultValue", "0")]
    [extern(JAVASCRIPT) Set("IsIntrinsic", "true")]
    /** A platform-specific type that is used to represent a pointer or a handle. */
    public intrinsic struct IntPtr
    {
        public static readonly IntPtr Zero;

        public static int Size
        {
            get
            {
                if defined(CPLUSPLUS)
                @{
                    return sizeof(void*);
                @}
                else if defined(JAVASCRIPT)
                @{
                    return -1;
                @}
                else
                    build_error;
            }
        }

        public static bool operator == (IntPtr left, IntPtr right)
        {
            if defined(CPLUSPLUS || JAVASCRIPT)
            @{
                return $0 == $1;
            @}
            else
                build_error;
        }

        public static bool operator != (IntPtr left, IntPtr right)
        {
            if defined(CPLUSPLUS || JAVASCRIPT)
            @{
                return $0 != $1;
            @}
            else
                build_error;
        }

        public static IntPtr operator +(IntPtr pointer, int offset)
        {
            if defined(CPLUSPLUS)
            @{
                return (void*)((uint8_t*)$0 + $1);
            @}
            else
                throw new NotSupportedException();
        }

        public static IntPtr Add(IntPtr pointer, int offset)
        {
            if defined(CPLUSPLUS)
            @{
                return (void*)((uint8_t*)$0 + $1);
            @}
            else
                throw new NotSupportedException();
        }

        [extern(JAVASCRIPT) Set("IsIntrinsic", "true")]
        public override bool Equals(object o)
        {
            return base.Equals(o);
        }

        [extern(JAVASCRIPT) Set("IsIntrinsic", "true")]
        public override int GetHashCode()
        {
            if defined(CPLUSPLUS)
            @{
                if (sizeof(void*) > 4)
                {
                    union
                    {
                        void *ptr;
                        uint32_t data[2];
                    } u;
                    u.ptr = *$$;
                    return u.data[0] ^ u.data[1];
                }
                else
                    return (int)(intptr_t)*$$;
            @}
            else if defined(JAVASCRIPT)
            @{
                return $$;
            @}
            else
                return base.GetHashCode();
        }

        [extern(JAVASCRIPT) Set("IsIntrinsic", "true")]
        [extern(CPLUSPLUS) Require("Source.Include", "inttypes.h")] // Needed for PRIxPTR
        [extern(ANDROID) Require("PreprocessorDefinition", "__STDC_FORMAT_MACROS")] // Needed for PRIxPTR
        public override string ToString()
        {
            if defined(CPLUSPLUS)
            @{
                char buf[19];
                int len = snprintf(buf, sizeof(buf), "0x%" PRIxPTR, *(intptr_t*)$$);
                return uString::Ansi(buf, len);
            @}
            else if defined(JAVASCRIPT)
            @{
                return "IntPtr";
            @}
            else
                return base.ToString();
        }
    }
}
