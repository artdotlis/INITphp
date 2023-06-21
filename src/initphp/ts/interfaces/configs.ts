interface FromTo {
    [name: string]: {
        from: string;
        to: string;
    };
}

interface PrCopy {
    initphp: FromTo;
}

interface ConfConPrT {
    copy: PrCopy;
    conf: string;
    production: boolean;
}

export { ConfConPrT, FromTo };
